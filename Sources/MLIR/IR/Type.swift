import CMLIR

public struct Type<MLIR: MLIRConfiguration>: Equatable, MLIRConfigurable, OpaqueStorageRepresentable
{
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirTypeParseGet, source)
  }
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.bridgedValue == rhs.bridgedValue
  }

  init(storage: BridgingStorage<MlirType, OwnedByMLIR>) { self.storage = storage }
  let storage: BridgingStorage<MlirType, OwnedByMLIR>
}

// MARK: - Bridging

extension Type {
  public init?(_ bridgedValue: MlirType) {
    guard let type = Self.borrow(bridgedValue) else { return nil }
    self = type
  }
  public var bridgedValue: MlirType { .borrow(self) }

  /**
   Convenience accessor for getting the `MlirContext`
   */
  public static var ctx: MlirContext { MLIR.ctx }
}

extension MlirType: Bridged, CEquatable {
  static let areEqual = mlirTypeEqual
  static let isNull = mlirTypeIsNull
}
