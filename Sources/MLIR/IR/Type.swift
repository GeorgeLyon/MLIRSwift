
import CMLIR

public extension MLIRConfiguration {
  typealias `Type` = MLIR.`Type`<Self>
}

public protocol TypeClass {
  associatedtype MLIR: MLIRConfiguration
  static var type: Type<MLIR> { get }
}

public struct Type<MLIR: MLIRConfiguration>:
  MLIRConfigurable,
  MlirStructWrapper
{
  public init(parsing source: String) throws {
    try self.init(isNull: mlirTypeIsNull) {
      source.withUnsafeMlirStringRef { mlirTypeParseGet(MLIR.context.c, $0) }
    }
  }
  init(c: MlirType) {
    self.c = c
  }
  let c: MlirType
}
