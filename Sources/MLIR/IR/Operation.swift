
import CMLIR

extension MLIRConfiguration {
    public typealias Operation = MLIR.Operation<Self>
}

public struct Operation<MLIR: MLIRConfiguration>:
    MlirStructWrapper,
    MlirStringCallbackStreamable,
    Destroyable
{
    public typealias Region = MLIR.Region
    public typealias Block = MLIR.Block
    
    public static func create(
        name: String,
        resultTypes: [Type<MLIR>] = [],
        operands: [Value] = [],
        ownedRegions: [Owned<Region>] = [],
        attributes: [NamedAttribute] = [:],
        file: StaticString = #file, line: Int = #line, column: Int = #column
    ) -> Owned<Operation>
    {
        let location = MLIR.location(file: file, line: line, column: column)
        let operation = name.withUnsafeMlirStringRef { name -> Operation in
            var state = mlirOperationStateGet(name, location.c)
            resultTypes.withUnsafeMlirStructs { resultTypes in
                mlirOperationStateAddResults(&state, resultTypes.count, resultTypes.baseAddress)
            }
            operands.withUnsafeMlirStructs { operands in
                mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
            }
            ownedRegions.map { $0.releasingOwnership() }.withUnsafeMlirStructs { regions in
                mlirOperationStateAddOwnedRegions(&state, regions.count, regions.baseAddress)
            }
            attributes.withUnsafeMlirStructs { attributes in
                mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
            }
            return Operation(c: mlirOperationCreate(&state))
        }
        return Owned.assumingOwnership(of: operation)
    }
    
    public struct Regions: RandomAccessCollection {
        public let startIndex = 0
        public let endIndex: Int
        public subscript(position: Int) -> Region {
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
        public subscript(position: Int) -> NamedAttribute {
            NamedAttribute(c: mlirOperationGetAttribute(operation.c, position))
        }
        public subscript(_ name: String) -> Attribute {
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
    
    func destroy() {
        mlirOperationDestroy(c)
    }
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirOperationPrint(c, unsafeCallback, userData)
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
