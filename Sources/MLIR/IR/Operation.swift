import CMLIR

public struct Operation<Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {

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

  init(storage: BridgingStorage<MlirOperation, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirOperation, Ownership>

  fileprivate init(
    dialect: MLIR.Dialect?,
    name: String,
    attributes: MLIR.NamedAttributes,
    operands: [MLIR.Value],
    resultTypes: [MLIR.`Type`],
    regions: [MLIR.Region<OwnedBySwift>],
    location: Location
  )
  where
    Ownership == OwnedBySwift
  {
    let fullyQualifiedName = dialect.map { "\($0.namespace).\(name)" } ?? name
    self = .assumeOwnership(
      of: fullyQualifiedName.withUnsafeMlirStringRef { name in
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
}

public struct OperationResults: RandomAccessCollection {
  public let startIndex = 0
  public var endIndex: Int { mlirOperationGetNumResults(c) }
  public subscript(position: Int) -> MLIR.Value {
    .borrow(mlirOperationGetResult(c, position))
  }
  fileprivate let c: MlirOperation
}

// MARK: - Building Operations

public struct OperationBuilder {

  public struct GenericBuilder {

    public mutating func build(
      _ dialect: Dialect,
      _ name: String,
      attributes: MLIR.NamedAttributes = [:],
      operands: [MLIR.Value] = [],
      resultTypes: [MLIR.`Type`],
      @RegionBuilder regions: () -> [RegionBuilder.Region] = { [] },
      file: StaticString = #file, line: Int = #line, column: Int = #column
    ) -> OperationResults {
      let location = Location(file: file, line: line, column: column)
      let operation = Operation(
        dialect: dialect,
        name: name,
        attributes: attributes,
        operands: operands,
        resultTypes: resultTypes,
        regions: regions(),
        location: location.called(by: caller))
      operations.append(operation)
      return operation.results
    }

    public mutating func build(
      _ dialect: Dialect,
      _ name: String,
      attributes: MLIR.NamedAttributes = [:],
      operands: [MLIR.Value] = [],
      @RegionBuilder regions: () -> [RegionBuilder.Region] = { [] },
      file: StaticString = #file, line: Int = #line, column: Int = #column
    ) {
      build(
        dialect, name,
        attributes: attributes,
        operands: operands,
        resultTypes: [],
        regions: regions)
    }

    fileprivate let caller: Location
    fileprivate var operations: [Operation<OwnedBySwift>] = []
  }

  public mutating func buildGenericOperation<T>(
    file: StaticString, line: Int, column: Int,
    _ body: (inout GenericBuilder) throws -> T
  ) rethrows -> T {
    let location = Location(file: file, line: line, column: column)
    var builder = GenericBuilder(caller: location)
    let result = try body(&builder)
    operations.append(contentsOf: builder.operations)
    return result
  }

  mutating func buildBuiltinOp(
    _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    resultTypes: [MLIR.`Type`] = [],
    regions: [RegionBuilder.Region] = [],
    file: StaticString, line: Int, column: Int
  ) -> OperationResults {
    let location = Location(file: file, line: line, column: column)
    let operation = Operation(
      dialect: nil,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: resultTypes,
      regions: regions,
      location: location)
    operations.append(operation)
    return operation.results
  }

  static func build(
    caller: Location? = nil,
    _ body: (inout Self) throws -> Void
  ) rethrows -> [Operation<OwnedBySwift>] {
    var builder = Self()
    try body(&builder)
    return builder.operations
  }
  private var operations: [Operation<OwnedBySwift>] = []
}

// MARK: - Bridging

extension MlirOperation: Bridged, CEquatable, Destroyable {
  typealias Pointer = UnsafeMutableRawPointer
  typealias SwiftRepresentation = Operation
  static let destroy = mlirOperationDestroy
  static let areEqual = mlirOperationEqual
  static let isNull = mlirOperationIsNull
}
