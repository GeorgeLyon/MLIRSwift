
import CCoreMLIR

extension MLIRConfiguration {
  public typealias Operation = CoreMLIR.Operation<Self>
}

public struct Operation<MLIR: MLIRConfiguration>:
  MlirStructWrapper,
  MlirStringCallbackStreamable,
  Destroyable
{
  public struct Regions: RandomAccessCollection {
    public let startIndex = 0
    public let endIndex: Int
    public subscript(position: Int) -> MLIR.Region {
      Region(c: mlirOperationGetRegion(operation.c, position))
    }
    fileprivate init(operation: Operation) {
      self.operation = operation
      self.endIndex = mlirOperationGetNumRegions(operation.c)
    }
    private let operation: Operation
  }
  public var regions: Regions {
    return Regions(operation: self)
  }
  
  public struct Attributes: RandomAccessCollection {
    public let startIndex = 0
    public let endIndex: Int
    public subscript(position: Int) -> (key: String, value: MLIR.Attribute) {
      let namedAttribute = mlirOperationGetAttribute(operation.c, position)
      return (namedAttribute.name.string, Attribute(c: namedAttribute.attribute))
    }
    public subscript(_ name: String) -> MLIR.Attribute {
      name.withUnsafeMlirStringRef {
        Attribute(c: mlirOperationGetAttributeByName(operation.c, $0))
      }
    }
    fileprivate init(operation: Operation) {
      self.operation = operation
      self.endIndex = mlirOperationGetNumAttributes(operation.c)
    }
    private let operation: Operation
  }
  public var attributes: Attributes {
    Attributes(operation: self)
  }
  
  public struct Results: MemberCollection, RandomAccessCollection {
    public static var keyPath: KeyPath<Operation, Results> { \.results }
    public let startIndex = 0
    public let endIndex: Int
    public subscript(position: Int) -> Value {
      Value(c: mlirOperationGetResult(operation.c, position))
    }
    fileprivate init(operation: Operation) {
      self.operation = operation
      self.endIndex = mlirOperationGetNumResults(operation.c)
    }
    private let operation: Operation
  }
  public var results: Results {
    Results(operation: self)
  }
  
  public typealias DebugInfoStyle = _OperationDebugInfoStyle
  public func withPrintingOptions(
    elideElementsAttributesLargerThan: Int32? = nil,
    debugInformationStyle: DebugInfoStyle = nil,
    alwaysPrintInGenericForm: Bool = false,
    useLocalScope: Bool = false) -> TextOutputStreamable
  {
    return OperationWithPrintingOptions(
      operation: c,
      options: .init(
        elideElementsAttributesLargerThan: elideElementsAttributesLargerThan,
        debugInformationStyle: debugInformationStyle,
        alwaysPrintInGenericForm: alwaysPrintInGenericForm,
        useLocalScope: useLocalScope))
  }
  
  public struct Builder: BuilderProtocol {
    
    public func build<Values>(
      _ name: String,
      results: TypeList<MLIR, Values, Results, Void>,
      operands: [ValueProtocol] = [],
      attributes: MLIR.NamedAttributes = [:],
      regions: Optional<(MLIR.Region.Builder) throws -> Void> = nil,
      file: StaticString = #file, line: Int = #line, column: Int = #column
    ) rethrows -> Values {
      let location = MLIR.location(file: file, line: line, column: column)
      let operation = try Operation(
        name,
        resultTypes: results.types,
        operands: operands,
        attributes: attributes,
        regions: regions,
        location: location)
      producer.produce(operation)
      return results.values(from: operation)
    }
    
    public func build(
      _ name: String,
      operands: [ValueProtocol] = [],
      attributes: MLIR.NamedAttributes = [:],
      regions: Optional<(MLIR.Region.Builder) throws -> Void> = nil,
      file: StaticString = #file, line: Int = #line, column: Int = #column
    ) rethrows {
      let location = MLIR.location(file: file, line: line, column: column)
      let operation = try Operation(
        name,
        resultTypes: [],
        operands: operands,
        attributes: attributes,
        regions: regions,
        location: location)
      producer.produce(operation)
    }
    
    let producer: Producer<Operation>
  }
  
  func destroy() {
    mlirOperationDestroy(c)
  }
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirOperationPrint(c, unsafeCallback, userData)
  }
  init(c: MlirOperation) {
    self.c = c
  }
  let c: MlirOperation
  
  private init(
    _ name: String,
    resultTypes: [MLIR.`Type`] = [],
    operands: [ValueProtocol] = [],
    attributes: MLIR.NamedAttributes = [:],
    regions: Optional<(MLIR.Region.Builder) throws -> Void>,
    location: Location
  ) rethrows {
    c = try name.withUnsafeMlirStringRef { name in
      try operands.map(\.value).withUnsafeMlirStructs { operands in
        try resultTypes.withUnsafeMlirStructs { resultTypes in
          try attributes.withUnsafeMlirStructs { attributes in
            try MLIR.Region.Builder
              .products(regions)
              .withUnsafeMlirStructs { regions in
                var state = mlirOperationStateGet(name, location.c)
                mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
                mlirOperationStateAddResults(&state, resultTypes.count, resultTypes.baseAddress)
                mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
                mlirOperationStateAddOwnedRegions(&state, regions.count, regions.baseAddress)
                return mlirOperationCreate(&state)
              }
          }
        }
      }
    }
  }
}

public enum _OperationDebugInfoStyle: ExpressibleByNilLiteral {
  case none
  case standard
  case pretty
  
  public init(nilLiteral: ()) {
    self = .none
  }
}

// MARK: - Private

private struct OperationWithPrintingOptions: MlirStringCallbackStreamable {
  
  struct PrintingOptions {
    var elideElementsAttributesLargerThan: Int32? = nil
    var debugInformationStyle: _OperationDebugInfoStyle = nil
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
        mlirOpPrintingFlagsEnableDebugInfo(c, 0)
      case .pretty:
        mlirOpPrintingFlagsEnableDebugInfo(c, 1)
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
  
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    options.withUnsafeMlirOpPrintingFlags { flags in
      mlirOperationPrintWithFlags(operation, flags, unsafeCallback, userData)
    }
  }
  
  fileprivate let operation: MlirOperation
  fileprivate let options: PrintingOptions
}
