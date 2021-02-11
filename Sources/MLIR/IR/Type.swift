import CMLIR

public struct Type: CRepresentable, Printable, Parsable {
  public init?(_ cRepresentation: MlirType) {
    self.init(c: cRepresentation)
  }
  public var cRepresentation: MlirType { c }

  public var context: Context {
    Context(c: mlirTypeGetContext(c))!
  }

  let c: MlirType

  static let isNull = mlirTypeIsNull
  static let print = mlirTypePrint
  static let parse = mlirTypeParseGet
}
