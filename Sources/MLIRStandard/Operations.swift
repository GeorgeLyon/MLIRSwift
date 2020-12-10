
import MLIR

public struct Constant<MLIR: ProvidesStandardDialect>: OperationProtocol {
  public init(value: MLIR.Attribute, type: MLIR.`Type`) {
    attributes = ["value": value]
    resultTypes = [type]
  }
  public var dialect: MLIR.RegisteredDialect { .std }
  public var operationName: String { "constant" }
  public let attributes: MLIR.NamedAttributes
  public let resultTypes: [MLIR.`Type`]
  public typealias Results = (MLIR.`Value`)
}

public struct Dim<MLIR: ProvidesStandardDialect>: OperationProtocol {
  public init(of value: MLIR.Value, _ i: MLIR.Value) {
    operands = [value, i]
    resultTypes = [.index]
  }
  public var dialect: MLIR.RegisteredDialect { .std }
  public var operationName: String { "dim" }
  public let operands: [MLIR.Value]
  public let resultTypes: [MLIR.`Type`]
  public typealias Results = (MLIR.`Value`)
}

public struct Return<MLIR: ProvidesStandardDialect>: OperationProtocol {
  public init() { }
  public var dialect: MLIR.RegisteredDialect { .std }
  public var operationName: String { "return" }
}
