import CMLIR

// MARK: - Public

public struct Diagnostic: Swift.Error {
  public enum Severity: Comparable {
    case remark, note, warning, error
  }

  public let location: Location
  public let severity: Severity
  public let notes: [Diagnostic]
  public let message: String

  init(_ unsafeDiagnostic: UnsafeDiagnostic) {
    self.location = unsafeDiagnostic.location
    self.severity = unsafeDiagnostic.severity
    self.notes = unsafeDiagnostic.notes.map(Diagnostic.init)
    self.message = "\(unsafeDiagnostic)"
  }
}

// MARK: - Internal

struct UnsafeDiagnostic: CRepresentable, Printable {

  struct Notes: Sequence {
    func makeIterator() -> Iterator {
      return Iterator(parent: parent)
    }
    struct Iterator: IteratorProtocol {
      init(parent: MlirDiagnostic) {
        self.parent = parent
        self.count = mlirDiagnosticGetNumNotes(parent)
      }
      mutating func next() -> UnsafeDiagnostic? {
        guard index < count else { return nil }
        let diagnostic = UnsafeDiagnostic(c: mlirDiagnosticGetNote(parent, index))
        index += 1
        return diagnostic
      }
      private let parent: MlirDiagnostic
      private let count: Int
      private var index = 0
    }
    fileprivate let parent: MlirDiagnostic
  }

  var location: Location { Location(c: mlirDiagnosticGetLocation(c)) }
  var severity: Diagnostic.Severity {
    Diagnostic.Severity(c: mlirDiagnosticGetSeverity(c))
  }
  var notes: Notes { Notes(parent: c) }

  let c: MlirDiagnostic
  
  static let print = mlirDiagnosticPrint
}

enum DiagnosticHandlingDirective {
  case stop
  case `continue`

  fileprivate var logicalResult: MlirLogicalResult {
    switch self {
    case .stop:
      return mlirLogicalResultSuccess()
    case .continue:
      return mlirLogicalResultFailure()
    }
  }
}

/**
 - note: This type is named `Registration`, unlike the wrapped C type, so it would be more consistent with other Swift APIs and not be confused with `ID` from the `Identifiable` protocol (which means something different).
 */
struct DiagnosticHandlerRegistration {
  fileprivate let id: MlirDiagnosticHandlerID
}

protocol DiagnosticHandler: AnyObject {
  /**
   - parameter unsafeDiagnostic: A `Diagnostic` which, along with any derived values such as `notes`, will only be valid for the duration of the call to `handle`.
   */
  func handle(_ unsafeDiagnostic: UnsafeDiagnostic) -> DiagnosticHandlingDirective
}

extension Context {
  func register(_ handler: DiagnosticHandler) -> DiagnosticHandlerRegistration {
    let userData = UnsafeMutableRawPointer(Unmanaged.passRetained(handler as AnyObject).toOpaque())
    let id = mlirContextAttachDiagnosticHandler(
      cRepresentation,
      mlirDiagnosticHandler,
      userData,
      mlirDeleteUserData)
    return DiagnosticHandlerRegistration(id: id)
  }
  func unregister(_ registration: DiagnosticHandlerRegistration) {
    mlirContextDetachDiagnosticHandler(cRepresentation, registration.id)
  }
}

// MARK: - Private

extension Diagnostic.Severity {
  fileprivate var c: MlirDiagnosticSeverity {
    switch self {
    case .error: return MlirDiagnosticError
    case .warning: return MlirDiagnosticWarning
    case .note: return MlirDiagnosticNote
    case .remark: return MlirDiagnosticRemark
    }
  }
  fileprivate init(c: MlirDiagnosticSeverity) {
    switch c {
    case MlirDiagnosticError: self = .error
    case MlirDiagnosticWarning: self = .warning
    case MlirDiagnosticNote: self = .note
    case MlirDiagnosticRemark: self = .remark

    /// We do not expect MLIR to return us diagnostics with invalid severities
    default: fatalError()
    }
  }
}

private func mlirDiagnosticHandler(
  mlirDiagnostic: MlirDiagnostic, userData: UnsafeMutableRawPointer!
) -> MlirLogicalResult {
  let handler =
    Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue() as! DiagnosticHandler
  return handler.handle(UnsafeDiagnostic(c: mlirDiagnostic)).logicalResult
}

private func mlirDeleteUserData(userData: UnsafeMutableRawPointer!) {
  Unmanaged<AnyObject>.fromOpaque(userData).release()
}
