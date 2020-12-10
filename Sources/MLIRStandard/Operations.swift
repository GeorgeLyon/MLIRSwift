
import MLIR

extension OperationProtocol where MLIR: ProvidesStandardDialect {
  public var dialect: MLIR.RegisteredDialect { .std }
}

public struct Constant<MLIR: ProvidesStandardDialect>: OperationProtocol {
  public init(value: MLIR.Attribute, type: MLIR.`Type`) {
    attributes = ["value": value]
    resultTypes = [type]
  }
  public let name = "constant"
  public let attributes: MLIR.NamedAttributes
  public let resultTypes: [MLIR.`Type`]
  public typealias Results = (MLIR.`Value`)
}

public struct Dim<MLIR: ProvidesStandardDialect>: OperationProtocol {
  public init(of value: MLIR.Value, _ i: MLIR.Value) {
    operands = [value, i]
    resultTypes = [.index]
  }
  public let name = "dim"
  public let operands: [MLIR.Value]
  public let resultTypes: [MLIR.`Type`]
  public typealias Results = (MLIR.`Value`)
}

public struct Return<MLIR: ProvidesStandardDialect>: OperationProtocol {
  public init() { }
  public let name = "return"
}
