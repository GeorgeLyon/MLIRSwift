import CMLIR

public struct Identifier: ExpressibleByStringLiteral,
  OpaqueStorageRepresentable
{
  public init(stringLiteral value: String) {
    self = .borrow(value.withUnsafeMlirStringRef { mlirIdentifierGet(MLIR.context, $0) })
  }
  init(storage: BridgingStorage<MlirIdentifier, OwnedByMLIR>) {
    self.storage = storage
  }
  let storage: BridgingStorage<MlirIdentifier, OwnedByMLIR>
}

extension MlirIdentifier: Bridged {}
