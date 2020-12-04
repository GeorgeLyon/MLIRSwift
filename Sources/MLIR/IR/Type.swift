
import CMLIR
import MLIRDialect
@_exported import struct MLIRDialect.Type

public extension MLIRConfiguration {
  typealias `Type` = MLIRDialect.`Type`<Self>
}

/**
 Represents an MLIR type as a Swift type. If you create a `TypeList` with `TypeClass`es, the `Values` will be associated with the same `TypeClass`. This enables the Swift type-checker to reason about MLIR types as well.
 */
public protocol TypeClass {
  associatedtype MLIR: MLIRConfiguration
  static var type: Type<MLIR> { get }
}

extension Type:
  MLIRConfigurable,
  MlirStructWrapper,
  MlirStringCallbackStreamable,
  CustomDebugStringConvertible,
  TextOutputStreamable
where
  MLIR: MLIRConfiguration
{
  public static func parsing(_ source: String) throws -> Self {
    try self.init(isNull: mlirTypeIsNull) {
      source.withUnsafeMlirStringRef { mlirTypeParseGet(MLIR.context.c, $0) }
    }
  }
  
  init(c: MlirType) {
    self = c.type()
  }
  var c: MlirType { .from(self) }
  
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirTypePrint(c, unsafeCallback, userData)
  }
}
