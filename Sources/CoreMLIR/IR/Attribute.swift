
import CCoreMLIR

public extension MLIRConfiguration {
  typealias Attribute = CoreMLIR.Attribute<Self>
  typealias NamedAttributes = CoreMLIR.NamedAttributes<Self>
}

public struct Attribute<MLIR: MLIRConfiguration>:
  MLIRConfigurable,
  MlirStructWrapper,
  MlirStringCallbackStreamable
{
  public init(parsing source: String) throws {
    try self.init(isNull: mlirAttributeIsNull) {
      source.withUnsafeMlirStringRef { mlirAttributeParseGet(MLIR.context.c, $0) }
    }
  }
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirAttributePrint(c, unsafeCallback, userData)
  }
  init(c: MlirAttribute) {
    self.c = c
  }
  let c: MlirAttribute
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
