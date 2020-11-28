
import CCoreMLIR

public extension MLIRConfiguration {
  typealias `Type` = CoreMLIR.`Type`<Self>
}

public protocol TypeClass {
  associatedtype MLIR: MLIRConfiguration
  static var type: Type<MLIR> { get }
}

public struct Type<MLIR: MLIRConfiguration>:
  MLIRConfigurable,
  MlirStructWrapper,
  MlirStringCallbackStreamable
{
  public init(parsing source: String) throws {
    try self.init(isNull: mlirTypeIsNull) {
      source.withUnsafeMlirStringRef { mlirTypeParseGet(MLIR.context.c, $0) }
    }
  }
  public init(c: MlirType) {
    self.c = c
  }
  public let c: MlirType
  
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirTypePrint(c, unsafeCallback, userData)
  }
}
