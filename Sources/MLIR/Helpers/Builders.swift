
public extension Region where Ownership == OwnedBySwift {
  @_functionBuilder
  enum Builder {
    public static func buildBlock(_ components: Region...) -> [Region] { components }
  }
}

public extension Block where Ownership == OwnedBySwift {
  @_functionBuilder
  enum Builder {
    public static func buildBlock(_ components: Block...) -> [Block] { components }
  }
}

public extension Operation where Ownership == OwnedBySwift {
  @_functionBuilder
  struct Builder {
    /**
     We hope that in the fullness of time result builders will support assignments, but for now there is no way to both build an operation and access its return values so we provide a more verbose API which enables this.
     */
    public mutating func build<Op: OperationProtocol>(
      _ op: Op
    ) -> Op.Results where Op.MLIR == MLIR {
      let operation = Operation(op)
      operations.append(operation)
      return Op.results(from: operation.results)
    }
    var operations: [Operation] = []
    
    public static func buildExpression<Op: OperationProtocol>(
      _ op: Op,
      file: StaticString = #file, line: Int = #line, column: Int = #column) -> Operation
    where Op.MLIR == MLIR
    {
      Operation(op, file: file, line: line, column: column)
    }
    public static func buildBlock(_ components: Operation...) -> [Operation] { components }
  }
}
