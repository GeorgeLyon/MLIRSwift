import CMLIR

/**
 An operation which has no constraints on its results
 */
public typealias AnyOperation = Operation<OperationResults>

/**
 Swift representation of an MLIR Operation

 The generic argument `Results` indicates how the operation should treat its results.
 */
public struct Operation<Results>: MlirRepresentable {

  public init(_ mlir: MlirOperation) {
    self.init(mlir: mlir)
  }
  public let mlir: MlirOperation

  /**
   - parameter resultTypes: `nil` implies type inference
   */
  public init(
    dialect: Dialect,
    name: String,
    attributes: [ContextualNamedAttribute] = [],
    operands: [Value] = [],
    resultTypes: [ContextualType]? = [],
    ownedRegions: [Region] = [],
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
  public init(
    builtin name: String,
    attributes: [ContextualNamedAttribute] = [],
    operands: [Value] = [],
    resultTypes: [ContextualType]? = [],
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: nil,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: resultTypes,
      ownedRegions: ownedRegions,
      location: location)
  }

  /**
   Returns a new operation with the result type erased
   */
  public var typeErased: AnyOperation {
    AnyOperation(mlir)
  }

  /**
   Returns `true` if verification of this operation is successful
   */
  public var isValid: Bool {
    mlirOperationVerify(mlir)
  }

  /**
   Returns the operation that owns this operation, if one exists
   */
  public var owningOperation: Operation? {
    Operation(mlirOperationGetParentOperation(mlir))
  }

  /**
   Returns the block that contains this operation, if one exists
   */
  public var owningBlock: Block? {
    Block(mlirOperationGetBlock(mlir))
  }

  /**
   Returns the context associated with this operation
   */
  public var context: UnownedContext {
    UnownedContext(mlirOperationGetContext(mlir))
  }

  private init(
    dialect: Dialect? = nil,
    name: String,
    attributes: [ContextualNamedAttribute],
    operands: [Value],
    resultTypes: [ContextualType]?,
    ownedRegions: [Region],
    location: Location
  ) {
    let context = location.context
    let qualifiedName: String
    if let dialect = dialect {
      qualifiedName = "\(dialect.namespace).\(name)"
    } else {
      qualifiedName = name
    }
    self.init(
      qualifiedName.withUnsafeMlirStringRef { name in
        operands.withUnsafeMlirRepresentation { operands in
          attributes.map { $0.in(context) }.withUnsafeMlirRepresentation { attributes in
            ownedRegions.withUnsafeMlirRepresentation { ownedRegions in
              var state = mlirOperationStateGet(name, location.mlir)
              mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
              mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
              mlirOperationStateAddOwnedRegions(
                &state, ownedRegions.count, ownedRegions.baseAddress)
              if let resultTypes = resultTypes {
                return
                  resultTypes
                  .map { $0.in(context) }
                  .withUnsafeMlirRepresentation { resultTypes in
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
}

// MARK: Attributes

extension Operation {
  public typealias Attributes = _OperationAttributes
  public var attributes: Attributes {
    Attributes(mlir: mlir)
  }
}

public struct _OperationAttributes {
  public subscript(_ name: String) -> Attribute? {
    get {
      Attribute(name.withUnsafeMlirStringRef { mlirOperationGetAttributeByName(mlir, $0) })
    }
    nonmutating set {
      name.withUnsafeMlirStringRef {
        if let newValue = newValue {
          mlirOperationSetAttributeByName(mlir, $0, newValue.mlir)
        } else {
          mlirOperationRemoveAttributeByName(mlir, $0)
        }
      }
    }
  }
  public func set(_ namedAttribute: NamedAttribute) {
    /// Eventually we may want to expose API in MLIR to do this less circuitously
    self[namedAttribute.name.stringValue] = namedAttribute.attribute
  }
  fileprivate let mlir: MlirOperation
}

// MARK: Regions

extension Operation {
  public typealias Regions = _OperationRegions
  public var regions: Regions {
    Regions(mlir: mlir)
  }
}

public struct _OperationRegions: RandomAccessCollection {
  public let startIndex = 0
  public var endIndex: Int { mlirOperationGetNumRegions(mlir) }
  public subscript(position: Int) -> Region {
    Region(mlirOperationGetRegion(mlir, position))
  }
  fileprivate let mlir: MlirOperation
}

// MARK: Results

public struct OperationResults: RandomAccessCollection {
  public let startIndex = 0
  public var endIndex: Int { mlirOperationGetNumResults(mlir) }
  public subscript(position: Int) -> Value {
    Value(mlirOperationGetResult(mlir, position))
  }
  fileprivate let mlir: MlirOperation
}

extension AnyOperation {
  public var results: Results {
    Results(mlir: mlir)
  }
}

public extension Operation {
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

// MARK: - Printing with Options

public enum _OperationDebugInfoStyle: ExpressibleByNilLiteral {
  case none
  case standard
  case pretty

  public init(nilLiteral: ()) {
    self = .none
  }
}

extension Operation {

  public typealias DebugInfoStyle = _OperationDebugInfoStyle

  public func withPrintingOptions(
    elideElementsAttributesLargerThan: Bool? = nil,
    debugInformationStyle: DebugInfoStyle = nil,
    alwaysPrintInGenericForm: Bool = false,
    useLocalScope: Bool = false
  ) -> TextOutputStreamable & CustomStringConvertible {
    return OperationWithPrintingOptions(
      operation: mlir,
      options: .init(
        elideElementsAttributesLargerThan: elideElementsAttributesLargerThan,
        debugInformationStyle: debugInformationStyle,
        alwaysPrintInGenericForm: alwaysPrintInGenericForm,
        useLocalScope: useLocalScope))
  }
}

private struct OperationWithPrintingOptions: TextOutputStreamable, CustomStringConvertible {

  struct PrintingOptions {
    var elideElementsAttributesLargerThan: Bool? = nil
    var debugInformationStyle: Operation.DebugInfoStyle = nil
    var alwaysPrintInGenericForm: Bool = false
    var useLocalScope: Bool = false

    func withUnsafeMlirOpPrintingFlags(_ body: (MlirOpPrintingFlags) -> Void) {
      let c = mlirOpPrintingFlagsCreate()
      if let value = elideElementsAttributesLargerThan {
        mlirOpPrintingFlagsEnableDebugInfo(c, value)
      }
      switch debugInformationStyle {
      case .none:
        break
      case .standard:
        mlirOpPrintingFlagsEnableDebugInfo(c, false)
      case .pretty:
        mlirOpPrintingFlagsEnableDebugInfo(c, true)
      }
      if alwaysPrintInGenericForm {
        mlirOpPrintingFlagsPrintGenericOpForm(c)
      }
      if useLocalScope {
        mlirOpPrintingFlagsUseLocalScope(c)
      }
      body(c)
      mlirOpPrintingFlagsDestroy(c)
    }
  }

  func write<Target: TextOutputStream>(to target: inout Target) {
    options.withUnsafeMlirOpPrintingFlags { flags in
      target.write { mlirOperationPrintWithFlags(operation, flags, $0, $1) }
    }
  }
  var description: String {
    "\(self)"
  }

  fileprivate let operation: MlirOperation
  fileprivate let options: PrintingOptions
}

// MARK: - Zero Result Operations

extension Operation where Results == () {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [ContextualNamedAttribute] = [],
    operands: [Value] = [],
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [],
      ownedRegions: ownedRegions,
      location: location)
  }

}

// MARK: - Single Result Operations

extension Operation where Results == Value {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [ContextualNamedAttribute] = [],
    operands: [Value] = [],
    resultType type: ContextualType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [type],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [ContextualNamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: Self.InferredResultType, _: Self.InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 1)
    return results[0]
  }

}
