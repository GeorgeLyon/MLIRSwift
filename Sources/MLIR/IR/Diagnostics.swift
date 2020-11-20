
import CMLIR

struct Diagnostic: Swift.Error {
    enum Severity: Comparable {
        case remark, note, warning, error
    }
    
    let location: Location
    let severity: Severity
    let notes: [Diagnostic]
    let description: String
    
    fileprivate init(_ unsafeDiagnostic: UnsafeDiagnostic) {
        self.location = unsafeDiagnostic.location
        self.severity = unsafeDiagnostic.severity
        self.notes = unsafeDiagnostic.notes.map(Diagnostic.init)
        self.description = "\(unsafeDiagnostic)"
    }
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

protocol DiagnosticsHandler: AnyObject {
    /**
     - parameter unsafeDiagnostic: A `Diagnostic` which, along with any derived values such as `notes`, will only be valid for the duration of the call to `handle`.
     */
    func handle(_ diagnostic: Diagnostic) -> DiagnosticHandlingDirective
}

extension Context {
    func register(_ handler: DiagnosticsHandler) -> DiagnosticHandlerRegistration {
        let userData = UnsafeMutableRawPointer(Unmanaged.passRetained(handler as AnyObject).toOpaque())
        let id = mlirContextAttachDiagnosticHandler(c, registeredDiagnosticHandler, userData)
        return DiagnosticHandlerRegistration(id: id)
    }
    func unregister(_ registration: DiagnosticHandlerRegistration) {
        mlirContextDetachDiagnosticHandler(c, registration.id)
    }
}

// MARK: - Private

private extension Diagnostic.Severity {
    var c: MlirDiagnosticSeverity {
        switch self {
        case .error: return MlirDiagnosticError
        case .warning: return MlirDiagnosticWarning
        case .note: return MlirDiagnosticNote
        case .remark: return MlirDiagnosticRemark
        }
    }
    init(c: MlirDiagnosticSeverity) {
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

private struct UnsafeDiagnostic: MlirTypeWrapper, MlirStringCallbackStreamable {
    
    struct Notes: Sequence {
        func makeIterator() -> Iterator {
            return Iterator(parent: parent)
        }
        struct Iterator: IteratorProtocol {
            init(parent: UnsafeDiagnostic) {
                self.parent = parent
                self.count = mlirDiagnosticGetNumNotes(parent.c)
            }
            mutating func next() -> UnsafeDiagnostic? {
                guard index < count else { return nil }
                let diagnostic = UnsafeDiagnostic(c: mlirDiagnosticGetNote(parent.c, index))
                index += 1
                return diagnostic
            }
            private let parent: UnsafeDiagnostic
            private let count: Int
            private var index = 0
        }
        fileprivate let parent: UnsafeDiagnostic
    }
    
    var location: Location { Location(c: mlirDiagnosticGetLocation(c)) }
    var severity: Diagnostic.Severity { Diagnostic.Severity(c: mlirDiagnosticGetSeverity(c)) }
    var notes: Notes { Notes(parent: self) }
    
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirDiagnosticPrint(c, unsafeCallback, userData)
    }
    
    fileprivate let c: MlirDiagnostic
}


private func registeredDiagnosticHandler(cDiagnostic: MlirDiagnostic, userData: UnsafeMutableRawPointer!) -> MlirLogicalResult {
    let diagnostic = Diagnostic(UnsafeDiagnostic(c: cDiagnostic))
    let handler = Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue() as! DiagnosticsHandler
    return handler.handle(diagnostic).logicalResult
}

private func mlirDeleteUserData(userData: UnsafeMutableRawPointer!) {
    Unmanaged<AnyObject>.fromOpaque(userData).release()
}
