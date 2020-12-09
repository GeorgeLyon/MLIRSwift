
import CMLIR

public extension MLIRConfiguration {
  typealias Context = MLIR.Context<Self>
}

public struct Context<MLIR: MLIRConfiguration>: OpaqueStorageRepresentable {
  public init() {
    self = .assumeOwnership(of: mlirContextCreate())!
    for dialect in MLIR.dialects.elements {
      dialect.register(with: self)
    }
  }
  init(storage: BridgingStorage<MlirContext, OwnedBySwift>) { self.storage = storage }
  let storage: BridgingStorage<MlirContext, OwnedBySwift>
}

extension MLIRConfiguration  {
  /// Convenient shorthand for writing `context.bridgedValue()`
  static var ctx: MlirContext { context.borrowedValue() }
}

extension MlirContext: Bridged, Destroyable {
  public static func context<MLIR: MLIRConfiguration>(of mlir: MLIR.Type) -> MlirContext {
    MLIR.ctx
  }
  static let destroy = mlirContextDestroy
  static let areEqual = mlirContextEqual
  static let isNull = mlirContextIsNull
}
