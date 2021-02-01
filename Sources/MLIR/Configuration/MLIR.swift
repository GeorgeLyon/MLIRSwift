import CMLIR

public struct MLIR {
  public static var context: MlirContext { shared.context }
  public static func resetContext() { shared.resetContext() }

  private mutating func resetContext() {
    mlirContextDestroy(context)
    context = mlirContextCreate()
  }
  private var context: MlirContext
  private init() {
    context = mlirContextCreate()
  }
  private static var shared = MLIR()
}

// MARK: - Naming Dance

/**
 In order to both have a top-level `MLIR` type and be able to reference other top-level types in this module as `MLIR.TypeName`, we first need to create an alias for each type under `_MLIR` and then reference that alias in an extension of `MLIR`.
 */
extension MLIR {
  public typealias Attribute = _MLIR._Attribute
  public typealias Block = _MLIR._Block
  public typealias BlockBuilder = _MLIR._BlockBuilder
  public typealias Diagnostic = _MLIR._Diagnostic
  public typealias Dialect = _MLIR._Dialect
  public typealias Identifier = _MLIR._Identifier
  public typealias Location = _MLIR._Location
  public typealias Module = _MLIR._Module
  public typealias NamedAttributes = _MLIR._NamedAttributes
  public typealias Operation = _MLIR._Operation
  public typealias OperationBuilder = _MLIR._OperationBuilder
  public typealias Ownership = _MLIR._Ownership
  public typealias Region = _MLIR._Region
  public typealias RegionBuilder = _MLIR._RegionBuilder
  public typealias `Type` = _MLIR._Type
  public typealias Value = _MLIR._Value
}

public enum _MLIR {
  public typealias _Attribute = Attribute
  public typealias _Block = Block
  public typealias _BlockBuilder = BlockBuilder
  public typealias _Diagnostic = Diagnostic
  public typealias _Dialect = Dialect
  public typealias _Identifier = Identifier
  public typealias _Location = Location
  public typealias _Module = Module
  public typealias _NamedAttributes = NamedAttributes
  public typealias _Operation = Operation
  public typealias _OperationBuilder = OperationBuilder
  public typealias _Ownership = Ownership
  public typealias _Region = Region
  public typealias _RegionBuilder = RegionBuilder
  public typealias _Type = Type
  public typealias _Value = Value
}
