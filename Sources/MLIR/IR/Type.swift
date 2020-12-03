
import CMLIR

public extension MLIRConfiguration {
  typealias `Type` = MLIR.`Type`<Self>
}

/**
 Represents an MLIR type as a Swift type. If you create a `TypeList` with `TypeClass`es, the `Values` will be associated with the same `TypeClass`. This enables the Swift type-checker to reason about MLIR types as well.
 */
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
