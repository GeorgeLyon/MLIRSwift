
import CMLIR

public struct Operation<MLIR: MLIRConfiguration, Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {
  public init<Op: OperationProtocol>(
    _ op: Op,
    file: StaticString = #file, line: Int = #line, column: Int = #column)
  where
    Op.MLIR == MLIR,
    Ownership == OwnedBySwift
  {
    let location = MLIR.location(file: file, line: line, column: column)
    
    /// For now, "func" is treated special
    let name: String
    if Op.self == Func<MLIR>.self {
      name = op.operationName
    } else {
      name = "\(op.dialect.namespace).\(op.operationName)"
    }
    
    self = name.withUnsafeMlirStringRef { name in
      op.operands.withUnsafeBorrowedValues { operands in
        op.attributes.withUnsafeBorrowedValues { attributes in
          op.regions.map { MlirRegion.assumeOwnership(of: $0) }.withUnsafeBufferPointer { regions in
            op.resultTypes.withUnsafeBorrowedValues { results in
              var state = mlirOperationStateGet(name, .borrow(location))
              mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
              mlirOperationStateAddResults(&state, results.count, results.baseAddress)
              mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
              mlirOperationStateAddOwnedRegions(&state, regions.count, regions.baseAddress)
              return .assumeOwnership(of: mlirOperationCreate(&state))!
            }
          }
        }
      }
    }
  }
  
  public struct Results: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirOperationGetNumResults(c) }
    public subscript(position: Int) -> MLIR.Value {
      .borrow(mlirOperationGetResult(c, position))
    }
    fileprivate let c: MlirOperation
  }
  public var results: Results { Results(c: .borrow(self)) }
  
  public struct Regions: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirOperationGetNumRegions(c)}
    public subscript(position: Int) -> MLIR.Region<OwnedByMLIR> {
      .borrow(mlirOperationGetRegion(c, position))!
    }
    fileprivate let c: MlirOperation
  }
  public var regions: Regions { Regions(c: .borrow(self)) }
  
  init(storage: BridgingStorage<MlirOperation, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirOperation, Ownership>
}

// MARK: - Operation Protocol

public protocol OperationProtocol {
  associatedtype MLIR: MLIRConfiguration
  var dialect: MLIR.RegisteredDialect { get }
  var operationName: String { get }
  var operands: [MLIR.Value] { get }
  var attributes: MLIR.NamedAttributes { get }
  var regions: [MLIR.Region<OwnedBySwift>] { get }
  var resultTypes: [MLIR.`Type`] { get }
  
  associatedtype Results = ()
  static func results(from operation: Operation) -> Results
}

public extension OperationProtocol {
  typealias Operation = MLIR.Operation<OwnedBySwift>
  var operands: [MLIR.Value] { [] }
  var attributes: MLIR.NamedAttributes { [:] }
  var regions: [MLIR.Region<OwnedBySwift>] { [] }
  var resultTypes: [MLIR.`Type`] { [] }
}

// MARK: - Bridging

extension MlirOperation: Bridged, CEquatable, Destroyable {
  typealias Pointer = UnsafeMutableRawPointer
  typealias SwiftRepresentation = Operation
  static let destroy = mlirOperationDestroy
  static let areEqual = mlirOperationEqual
  static let isNull = mlirOperationIsNull
}
