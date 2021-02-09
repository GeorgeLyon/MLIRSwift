
import CMLIR

public struct Identifier: CRepresentable, CustomStringConvertible {
  let c: MlirIdentifier
  
  public var description: String { mlirIdentifierStr(c).string }
}
