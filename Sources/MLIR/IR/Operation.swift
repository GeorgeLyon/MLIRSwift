import CMLIR

public struct Operation<Ownership: MLIR.Ownership, ResultStyle>: OpaqueStorageRepresentable {

  public init(
    _ dialect: MLIR.Dialect,
    _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    resultTypes: [MLIR.`Type`] = [],
    regions: [MLIR.Region<OwnedBySwift>] = [],
    location: Location
  )
  where
    Ownership == OwnedBySwift
  {
    self = Operation(
      "\(dialect.namespace).\(name)",
      attributes: attributes,
      operands: operands,
      resultTypes: resultTypes,
      regions: regions,
      location: location)
  }
  
  public typealias Results = OperationResults
  public var results: Results { Results(c: .borrow(self)) }

  public struct Regions: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirOperationGetNumRegions(c) }
    public subscript(position: Int) -> MLIR.Region<OwnedByMLIR> {
      .borrow(mlirOperationGetRegion(c, position))!
    }
    fileprivate let c: MlirOperation
  }
  public var regions: Regions { Regions(c: .borrow(self)) }
  
  init(
    _ name: String,
    attributes: MLIR.NamedAttributes,
    operands: [MLIR.Value],
    resultTypes: [MLIR.`Type`],
    regions: [MLIR.Region<OwnedBySwift>],
    location: Location
  )
  where
    Ownership == OwnedBySwift
  {
    self = .assumeOwnership(
      of: name.withUnsafeMlirStringRef { name in
        operands.withUnsafeBorrowedValues { operands in
          attributes.withUnsafeBorrowedValues { attributes in
            regions.map { MlirRegion.assumeOwnership(of: $0) }.withUnsafeBufferPointer { regions in
              resultTypes.withUnsafeBorrowedValues { results in
                var state = mlirOperationStateGet(name, .borrow(location))
                mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
                mlirOperationStateAddResults(&state, results.count, results.baseAddress)
                mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
                mlirOperationStateAddOwnedRegions(&state, regions.count, regions.baseAddress)
                return mlirOperationCreate(&state)
              }
            }
          }
        }
      })!
  }
  
  init(storage: BridgingStorage<MlirOperation, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirOperation, Ownership>
}

public struct OperationResults: RandomAccessCollection {
  public let startIndex = 0
  public var endIndex: Int { mlirOperationGetNumResults(c) }
  public subscript(position: Int) -> MLIR.Value {
    .borrow(mlirOperationGetResult(c, position))
  }
  fileprivate let c: MlirOperation
}

extension MlirOperation: Bridged, CEquatable, Destroyable {
  typealias Pointer = UnsafeMutableRawPointer
  typealias SwiftRepresentation = Operation
  static let destroy = mlirOperationDestroy
  static let areEqual = mlirOperationEqual
  static let isNull = mlirOperationIsNull
}
