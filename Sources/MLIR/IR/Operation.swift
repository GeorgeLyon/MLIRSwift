import CMLIR

public struct Operation: CRepresentable {
  public var attributes: Attributes {
    Attributes(c: c)
  }
  public var regions: Regions {
    Regions(c: c)
  }
  public var results: Results {
    Results(c: c)
  }

  public var isValid: Bool {
    mlirOperationVerify(c)
  }

  public var owningOperation: Operation? {
    Operation(c: mlirOperationGetParentOperation(c))
  }
  public var owningBlock: Block? {
    Block(c: mlirOperationGetBlock(c))
  }
  public var context: Context {
    Context(c: mlirOperationGetContext(c))!
  }

  let c: MlirOperation

  /**
   Creates an owned operation.
   */
  init?<T>(_ definition: Definition<T>, location: Location) {
    self.init(c: definition.createOperation(at: location))
  }

  static let isNull = mlirOperationIsNull
}

// MARK: - Attributes

extension Operation {
  public struct Attributes {
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
}

// MARK: - Regions

extension Operation {
  public struct Regions: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirOperationGetNumRegions(c) }
    public subscript(position: Int) -> Region {
      Region(c: mlirOperationGetRegion(c, position))!
    }
    fileprivate let c: MlirOperation
  }
}

// MARK: - Results

extension Operation {
  public struct Results: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirOperationGetNumResults(c) }
    public subscript(position: Int) -> Value {
      Value(c: mlirOperationGetResult(c, position))!
    }
    fileprivate let c: MlirOperation
  }
}

// MARK: - Operation Definition

/**
 `Definition` closely resembles `MlirOperationState` with a few notable caveats:
 - `Definition` includes Swift type-system information about the cardinality of results
 - `Definition` does not include location, making it easier to define an operation that is then used in various places
 */
extension Operation {

  public struct Definition<Results> {

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes: [MLIR.`Type`] = [],
      ownedRegions: [Region] = []
    )
    where
      Results == Operation.Results
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = resultTypes
      self.ownedRegions = ownedRegions
    }

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes: InferredResultType,
      ownedRegions: [Region] = []
    )
    where
      Results == Operation.Results
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = nil
      self.ownedRegions = ownedRegions
    }

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      ownedRegions: [Region] = []
    )
    where
      Results == ()
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = []
      self.ownedRegions = ownedRegions
    }

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultType: MLIR.`Type`,
      ownedRegions: [Region] = []
    )
    where
      Results == (Value)
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = [resultType]
      self.ownedRegions = ownedRegions
    }

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultType: InferredResultType,
      ownedRegions: [Region] = []
    )
    where
      Results == (Value)
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = nil
      self.ownedRegions = ownedRegions
    }

    init(
      builtin name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes: [MLIR.`Type`] = [],
      ownedRegions: [Region] = []
    ) {
      self.dialect = nil
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = resultTypes
      self.ownedRegions = ownedRegions
    }

    /// `nil` indicates the builtin dialect
    let dialect: Dialect?
    let name: String
    let attributes: [NamedAttribute]
    let operands: [Value]
    /// `nil` implies result type inference
    let resultTypes: [MLIR.`Type`]?
    let ownedRegions: [Region]

    fileprivate func createOperation(at location: Location) -> MlirOperation {
      let name: String
      if let dialect = dialect {
        name = "\(dialect.namespace).\(self.name)"
      } else {
        name = self.name
      }
      return name.withUnsafeMlirStringRef { name in
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
      }
    }
  }

}

// MARK: - Inferred Results

extension Operation {
  public struct InferredResultType {
    public static let inferred = Self()

    /**
     If it becomes interesting, we can implement the following function so we could do partial inference like so: `OperationDefinition(resultTypes: .inferred, .inferred(expecting: .integer(bitWidth: 1))`
     ```
     public static func inferred(expecting type: MLIR.`Type`) -> Self {

     }
     ```
     */
  }
}
