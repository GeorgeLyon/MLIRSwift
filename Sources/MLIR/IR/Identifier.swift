
import CMLIR

public struct Identifier: CRepresentable, CustomStringConvertible {
  public init(_ string: String, in context: Context) {
    c = string.withUnsafeMlirStringRef { mlirIdentifierGet(context.cRepresentation, $0) }
  }
  public var context: UnownedContext {
    UnownedContext(c: mlirIdentifierGetContext(c))!
  }
  public var description: String { mlirIdentifierStr(c).string }
  
  let c: MlirIdentifier
}
