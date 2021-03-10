import CMLIR

public protocol OperationProtocol {
  init(cRepresentation: MlirOperation)
  var cRepresentation: MlirOperation { get }
}

extension OperationProtocol {
  
  /**
   - parameter resultTypes: `nil` implies type inference
   */
  public init(
    dialect: Dialect,
    name: String,
    attributes: [MLIR.NamedAttribute] = [],
    operands: [MLIR.Value] = [],
    resultTypes: [MLIR.`Type`]? = [],
    ownedRegions: [MLIR.Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect as Dialect?,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: resultTypes,
      ownedRegions: ownedRegions,
      location: location)
  }
  
  /**
   - parameter resultTypes: `nil` implies type inference
   */
  init(
    dialect: Dialect? = nil,
    name: String,
    attributes: [MLIR.NamedAttribute],
    operands: [MLIR.Value],
    resultTypes: [MLIR.`Type`]?,
    ownedRegions: [MLIR.Region],
    location: Location
  ) {
    let qualifiedName: String
    if let dialect = dialect {
      qualifiedName = "\(dialect.namespace).\(name)"
    } else {
      qualifiedName = name
    }
    self.init(cRepresentation: qualifiedName.withUnsafeMlirStringRef { name in
      operands.withUnsafeCRepresentation { operands in
        attributes.withUnsafeCRepresentation { attributes in
          ownedRegions.withUnsafeCRepresentation { ownedRegions in
            var state = mlirOperationStateGet(name, location.c)
            mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
            mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
            mlirOperationStateAddOwnedRegions(
              &state, ownedRegions.count, ownedRegions.baseAddress)
            if let resultTypes = resultTypes {
              return resultTypes.withUnsafeCRepresentation { resultTypes in
                mlirOperationStateAddResults(&state, resultTypes.count, resultTypes.baseAddress)
                return mlirOperationCreate(&state)
              }
            } else {
              mlirOperationStateEnableResultTypeInference(&state)
              return mlirOperationCreate(&state)
            }
          }
        }
      }
    })
  }
  
  public typealias Attributes = _OperationAttributes
  public var attributes: Attributes {
    Attributes(c: cRepresentation)
  }
  
  public typealias Regions = _OperationRegions
  public var regions: Regions {
    Regions(c: cRepresentation)
  }
  
  public typealias Results = _OperationResults
  public var results: Results {
    Results(c: cRepresentation)
  }

  public var isValid: Bool {
    mlirOperationVerify(cRepresentation)
  }

  public var owningOperation: Operation? {
    Operation(c: mlirOperationGetParentOperation(cRepresentation))
  }
  public var owningBlock: Block? {
    Block(c: mlirOperationGetBlock(cRepresentation))
  }
  public var context: UnownedContext {
    UnownedContext(c: mlirOperationGetContext(cRepresentation))!
  }
}

public struct Operation: OperationProtocol, CRepresentable {
  public init(cRepresentation: MlirOperation) {
    self.c = cRepresentation
  }
  public var cRepresentation: MlirOperation { c }
  let c: MlirOperation
  
  static let isNull = mlirOperationIsNull
}

// MARK: - Attributes

public struct _OperationAttributes {
  public subscript(_ name: String) -> Attribute? {
    get {
      Attribute(c: name.withUnsafeMlirStringRef { mlirOperationGetAttributeByName(c, $0) })
    }
    nonmutating set {
      name.withUnsafeMlirStringRef {
        if let newValue = newValue {
          mlirOperationSetAttributeByName(c, $0, newValue.c)
        } else {
          mlirOperationRemoveAttributeByName(c, $0)
        }
      }
    }
  }
  public func set(_ namedAttribute: NamedAttribute) {
    /// Eventually we may want to expose API in MLIR to do this less circuitously
    self[namedAttribute.name.stringValue] = namedAttribute.attribute
  }
  fileprivate let c: MlirOperation
}

// MARK: - Regions

public struct _OperationRegions: RandomAccessCollection {
  public let startIndex = 0
  public var endIndex: Int { mlirOperationGetNumRegions(c) }
  public subscript(position: Int) -> Region {
    Region(c: mlirOperationGetRegion(c, position))!
  }
  fileprivate let c: MlirOperation
}

// MARK: - Results

public struct _OperationResults: RandomAccessCollection {
  public let startIndex = 0
  public var endIndex: Int { mlirOperationGetNumResults(c) }
  public subscript(position: Int) -> Value {
    Value(c: mlirOperationGetResult(c, position))!
  }
  fileprivate let c: MlirOperation
}

// MARK: - Typed Operation

public struct TypedOperation<Results>: OperationProtocol {
  public init(cRepresentation: MlirOperation) {
    self.c = cRepresentation
  }
  public var cRepresentation: MlirOperation { c }
  
  let c: MlirOperation

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    ownedRegions: [Region] = [],
    location: Location
  )
  where
    Results == ()
  {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultType: MLIR.`Type`,
    ownedRegions: [Region] = [],
    location: Location
  )
  where
    Results == (Value)
  {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [resultType],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultType: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  )
  where
    Results == (Value)
  {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

}

// MARK: - Inferred Results

public extension TypedOperation {
  typealias InferredResultType = _OperationInferredResultType
}
public struct _OperationInferredResultType {
  public static let inferred = Self()

  /**
   If it becomes interesting, we can implement the following function so we could do partial inference like so: `OperationDefinition(resultTypes: .inferred, .inferred(expecting: .integer(bitWidth: 1))`
   ```
   public static func inferred(expecting type: MLIR.`Type`) -> Self {

   }
   ```
   */
}
