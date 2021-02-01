import CMLIR

public struct Type: Equatable, OpaqueStorageRepresentable
{
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirTypeParseGet, source)
  }
  public static func == (lhs: Self, rhs: Self) -> Bool {
    MlirType.borrow(lhs) == MlirType.borrow(rhs)
  }

  init(storage: BridgingStorage<MlirType, OwnedByMLIR>) { self.storage = storage }
  let storage: BridgingStorage<MlirType, OwnedByMLIR>
}

// MARK: - Bridging

extension MLIR {
  public static func bridge(_ value: MlirType) -> Type? {
    .borrow(value)
  }
  public static func bridge(_ value: Type) -> MlirType {
    .borrow(value)
  }
}

extension MlirType: Bridged, CEquatable {
  static let areEqual = mlirTypeEqual
  static let isNull = mlirTypeIsNull
}
