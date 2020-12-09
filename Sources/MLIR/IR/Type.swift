
import CMLIR

public struct Type<MLIR: MLIRConfiguration>: MLIRConfigurable, OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirTypeParseGet, source)
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
  public var bridgedValue: MlirType { MlirType.borrow(self) }
  
  /**
   Convenience accessor for getting the `MlirContext`
   */
  public static var ctx: MlirContext { MLIR.ctx }
}

extension MlirType: Bridged {
  static let areEqual = mlirTypeEqual
  static let isNull = mlirTypeIsNull
}
