import CMLIR

/**
 Swift represention of an `MlirIdentifier`
 */
public struct Identifier: MlirRepresentable {

  /**
   Creates an identifier from a string
   */
  public init(_ string: String, in context: Context) {
    self.init(
      string.withUnsafeMlirStringRef {
        mlirIdentifierGet(context.mlir, $0)
      })
  }

  let mlir: MlirIdentifier

  public static func == (lhs: Self, rhs: Self) -> Bool {
    mlirIdentifierEqual(lhs.mlir, rhs.mlir)
  }

  /**
   The context that owns this identifier
   */
  public var context: UnownedContext {
    UnownedContext(mlirIdentifierGetContext(mlir))
  }

  /**
   A String representation of this identifier
   */
  public var stringValue: String {
    mlirIdentifierStr(mlir).string
  }

}

// MARK: - Printing

extension Identifier: CustomStringConvertible {
  public var description: String {
    stringValue
  }
}
