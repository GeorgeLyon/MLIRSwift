
import CMLIR
import MLIRDialect
@_exported import struct MLIRDialect.Type

public extension MLIRConfiguration {
  typealias `Type` = MLIRDialect.`Type`<Self>
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