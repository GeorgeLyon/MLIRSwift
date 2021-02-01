import CMLIR

public struct Module: OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(assumeOwnership, mlirModuleCreateParse, source)
  }
  public init(
    _ operations: (inout OperationBuilder) throws -> Void,
    file: StaticString = #file, line: Int = #line, column: Int = #column
  ) rethrows {
    let location = Location(file: file, line: line, column: column)
    self = .assumeOwnership(of: mlirModuleCreateEmpty(.borrow(location)))!
    /// Ensure that the module terminator is at the end
    try OperationBuilder.build(operations).reversed().forEach(body.operations.prepend)
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

// MARK: - Bridging

extension Module {
  public var bridgedValue: MlirModule { .borrow(self) }
}

extension MlirModule: Bridged, Destroyable {
  static let isNull = mlirModuleIsNull
  static let destroy = mlirModuleDestroy
}
