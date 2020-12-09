
import CMLIR

public struct Module<MLIR: MLIRConfiguration>: MLIRConfigurable, OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(assumeOwnership, mlirModuleCreateParse, source)
  }
  
  public var body: MLIR.Block<OwnedByMLIR> {
    .borrow(mlirModuleGetBody(.borrow(self)))!
  }
  public var operation: MLIR.Operation<OwnedByMLIR> {
    .borrow(mlirModuleGetOperation(.borrow(self)))!
  }
  
  init(storage: BridgingStorage<MlirModule, OwnedBySwift>) { self.storage = storage }
  let storage: BridgingStorage<MlirModule, OwnedBySwift>
}

extension MlirModule: Bridged, Destroyable {
  /// Modules do not implement equality
  static let areEqual: (MlirModule, MlirModule) -> Int32 = { _, _ in fatalError() }
  static let isNull = mlirModuleIsNull
  static let destroy = mlirModuleDestroy
}