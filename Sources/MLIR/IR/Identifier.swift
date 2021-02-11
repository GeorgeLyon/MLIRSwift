import CMLIR

public struct Identifier: CRepresentable, CustomStringConvertible {
  public init(_ string: String, in context: Context) {
    c = string.withUnsafeMlirStringRef { mlirIdentifierGet(context.cRepresentation, $0) }
  }
  public var context: Context {
    Context(c: mlirIdentifierGetContext(c))!
  }
  public var stringValue: String {
    mlirIdentifierStr(c).string
  }
  public var description: String {
    stringValue
  }

  let c: MlirIdentifier
}
