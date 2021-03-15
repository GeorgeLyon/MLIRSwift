import CMLIR

extension Context {

  /**
   Attempts to parse `source` as a module
   */
  public func parse(
    _ source: String,
    as type: Module.Type = Module.self
  ) throws -> Module {
    try parse(
      source,
      parse: mlirModuleCreateParse,
      isNull: mlirModuleIsNull,
      init: Module.init)
  }
  /**
   Attempts to parse `source` as an attribute
   */
  public func parse(
    _ source: String,
    as type: Attribute.Type = Attribute.self
  ) throws -> Attribute {
    try parse(
      source,
      parse: mlirAttributeParseGet,
      isNull: mlirAttributeIsNull,
      init: Attribute.init)
  }

  /**
   Attempts to parse `source` as a type
   */
  public func parse(
    _ source: String,
    as type: Type.Type = Type.self
  ) throws -> Type {
    try parse(
      source,
      parse: mlirTypeParseGet,
      isNull: mlirTypeIsNull,
      init: Type.init)
  }

  private func parse<T, U>(
    _ source: String,
    parse: (MlirContext, MlirStringRef) -> T,
    isNull: (T) -> Bool,
    init: (T) -> U
  ) throws -> U {
    let pair = collectDiagnostics(minimumSeverity: .error) {
      source.withUnsafeMlirStringRef {
        parse(mlir, $0)
      }
    }
    guard pair.diagnostics.isEmpty else {
      throw ParsingError(diagnostics: pair.diagnostics)
    }
    guard !isNull(pair.value) else {
      throw ParsingError(diagnostics: [])
    }
    return `init`(pair.value)
  }
}

public struct ParsingError: Swift.Error, CustomStringConvertible {
  public let diagnostics: [Diagnostic]

  public var description: String {
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
