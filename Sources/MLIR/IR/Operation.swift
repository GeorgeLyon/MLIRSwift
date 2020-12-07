
import CMLIR

extension MLIRConfiguration {
  public typealias Operation = MLIR.Operation<Self>
}

// MARK: - Operation Protocol

public protocol OperationProtocol {
  associatedtype MLIR: MLIRConfiguration
  static var dialect: MLIR.RegisteredDialect { get }
  static var name: String { get }
  
  associatedtype ResultTypes = [MLIR.`Type`]
  static var resultTypes: ResultTypes { get }
  static func types(for resultTypes: ResultTypes) -> [MLIR.`Type`]
  
  associatedtype Results = [MLIR.Value]
  static func results(of op: MLIR.Operation) -> Results
  
  var operands: [MLIR.Value] { get }
  var attributes: MLIR.NamedAttributes { get }
  var regions: () -> Owned<[MLIR.Region]> { get }
}

public extension OperationProtocol where ResultTypes == [MLIR.`Type`] {
  static func types(for resultTypes: ResultTypes) -> [MLIR.`Type`] { resultTypes }
}

public extension OperationProtocol where Results == Operation<MLIR>.Results {
  static func results(of op: MLIR.Operation) -> Results { op.results }
}

extension OperationProtocol {
  func withUnsafeOperationState<T>(at location: MlirLocation, _ body: (UnsafePointer<MlirOperationState>) -> T) -> T {
    "\(Self.dialect.namespace).\(Self.name)".withUnsafeMlirStringRef { name in
      operands.withUnsafeMlirStructs { operands in
        Self.types(for: Self.resultTypes).withUnsafeMlirStructs { results in
          attributes.withUnsafeMlirStructs { attributes in
            regions().consume().withUnsafeMlirStructs { regions in
              var state = mlirOperationStateGet(name, location)
              mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
              mlirOperationStateAddResults(&state, results.count, results.baseAddress)
              mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
              mlirOperationStateAddOwnedRegions(&state, regions.count, regions.baseAddress)
              return body(&state)
            }
          }
        }
      }
    }
  }
}

// MARK: - Operation

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
    public subscript(position: Int) -> MLIR.Value {
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
  
  @_functionBuilder
  public struct Builder {
    public struct Component {
      let get: () -> Operation
    }
    public static func buildExpression<Op: OperationProtocol>(
      _ op: Op,
      file: StaticString = #file, line: Int = #line, column: Int = #column) -> Component
    {
      let location = MLIR.location(file: file, line: line, column: column)
      return Component { Operation(op, at: location) }
    }
    public static func buildBlock(_ components: Component...) -> Owned<[Operation]> {
      return Owned(components.map { $0.get() })
    }
    
    public init() { }
    public mutating func build<Op: OperationProtocol>(
      _ op: Op,
      file: StaticString = #file, line: Int = #line, column: Int = #column) -> Op.Results
    where Op.MLIR == MLIR
    {
      let location = MLIR.location(file: file, line: line, column: column)
      let operation = Operation(op, at: location)
      operations.append(operation)
      return Op.results(of: operation)
    }
    public private(set) var operations: Owned<[Operation]> = Owned([])
  }
  fileprivate init<Op: OperationProtocol>(_ op: Op, at location: Location) {
    c = op.withUnsafeOperationState(at: location.c, mlirOperationCreate)
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
