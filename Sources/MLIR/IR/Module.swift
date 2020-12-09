
import CMLIR

public struct Module<MLIR: MLIRConfiguration>: OpaqueStorageRepresentable {
  public init(parsing source: String) throws {
    let c = source.withUnsafeMlirStringRef { mlirModuleCreateParse(MLIR.ctx, $0) }
    guard let module = Self.assumeOwnership(of: c) else {
      fatalError()
    }
    self = module
  }
  
  init(storage: Storage) {
    self.storage = storage
  }
  let storage: BridgingStorage<MlirModule, OwnedBySwift>
}

extension MlirModule: Bridged, Destroyable {
  /// Modules do not implement equality
  static let areEqual: (MlirModule, MlirModule) -> Int32 = { _, _ in fatalError() }
  static let isNull = mlirModuleIsNull
  static let destroy = mlirModuleDestroy
}
