
import CMLIR
import MLIRDialect
@_exported import struct MLIRDialect.Attribute

public extension MLIRConfiguration {
  typealias Attribute = MLIRDialect.Attribute<Self>
  typealias NamedAttributes = MLIR.NamedAttributes<Self>
}

extension Attribute:
  MLIRConfigurable,
  MlirStructWrapper,
  MlirStringCallbackStreamable,
  CustomDebugStringConvertible,
  TextOutputStreamable
where
  MLIR: MLIRConfiguration
{
  public static func parse(_ source: String) throws -> Attribute {
    try self.init(isNull: mlirAttributeIsNull) {
      source.withUnsafeMlirStringRef { mlirAttributeParseGet(MLIR.context.c, $0) }
    }
  }
  public var type: MLIR.`Type` {
    `Type`(c: mlirAttributeGetType(c))
  }
  
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirAttributePrint(c, unsafeCallback, userData)
  }
  init(c: MlirAttribute) {
    self = c.attribute()
  }
  var c: MlirAttribute { MlirAttribute.from(self) }
}

public struct NamedAttributes<MLIR: MLIRConfiguration>: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, MLIR.Attribute)...) {
    self.names = elements.map(\.0)
    self.attributes = elements.map(\.1)
  }
  func withUnsafeMlirStructs<T>(_ body: (UnsafeBufferPointer<MlirNamedAttribute>) throws -> T) rethrows -> T {
    return try names.withUnsafeMlirStringRefs { names in
      precondition(names.count == attributes.count)
      let namedAttributes = zip(names, attributes.map(\.c)).map(mlirNamedAttributeGet)
      return try namedAttributes.withUnsafeBufferPointer(body)
    }
  }
  private let names: [String]
  private let attributes: [MLIR.Attribute]
}
