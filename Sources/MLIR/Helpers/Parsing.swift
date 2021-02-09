import CMLIR

extension Context {
  func parse(_ type: Module.Type = Module.self, from source: String) throws -> Module {
    try _parse(source: source)
  }
  func parse(_ type: Attribute.Type = Attribute.self, from source: String) throws -> Attribute {
    try _parse(source: source)
  }
}

// MARK: - Implementation

protocol Parsable {
  associatedtype CRepresentation
  init?(c: CRepresentation)
  static var parse: (MlirContext, MlirStringRef) -> CRepresentation { get }
}

extension Context {
  func _parse<T: Parsable>(source: String) throws -> T {
    let pair = collectDiagnostics(minimumSeverity: .error) {
      source.withUnsafeMlirStringRef { T(c: T.parse(c, $0)) }
    }
    guard pair.diagnostics.isEmpty else {
      throw ParsingError(diagnostics: pair.diagnostics)
    }
    guard let value = pair.value else {
      throw ParsingError(diagnostics: [])
    }
    return value
  }
}

struct ParsingError: Swift.Error, CustomStringConvertible {
  let diagnostics: [Diagnostic]

  var description: String {
    switch diagnostics.count {
    case 0:
      return "Unknown Error"
    case 1:
      return diagnostics[0].message
    default:
      return """
        \(diagnostics.count) errors:
        \(diagnostics.map { "  - \($0.message)" }.joined(separator: "\n"))
        """
    }
  }
}
