
import CMLIR

public struct OperationReference: MlirStructWrapper, MlirStringCallbackStreamable, Destroyable {
    
    public struct Regions: RandomAccessCollection {
        public let startIndex = 0
        public let endIndex: Int
        public subscript(position: Int) -> RegionReference {
            RegionReference(c: mlirOperationGetRegion(operation.c, position))
        }
        fileprivate init(operation: OperationReference) {
            self.operation = operation
            self.endIndex = mlirOperationGetNumRegions(operation.c)
        }
        private let operation: OperationReference
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
        fileprivate init(operation: OperationReference) {
            self.operation = operation
            self.endIndex = mlirOperationGetNumAttributes(operation.c)
        }
        private let operation: OperationReference
    }
    public var attributes: Attributes {
        Attributes(operation: self)
    }
    
    public enum DebugInfoStyle: ExpressibleByNilLiteral {
        case none
        case standard
        case pretty
        
        public init(nilLiteral: ()) {
            self = .none
        }
    }
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

// MARK: - Creating Operations

extension MLIRConfiguration {
    static func operation(
        name: String,
        resultTypes: [Type] = [],
        operands: [Value] = [],
        ownedRegions: [Owned<RegionReference>] = [],
        attributes: [NamedAttribute] = [:],
        file: StaticString = #file, line: Int = #line, column: Int = #column
    ) -> Owned<OperationReference>
    {
        let location = self.location(file: file, line: line, column: column)
        let operation = name.withUnsafeMlirStringRef { name -> OperationReference in
            var state = mlirOperationStateGet(name, location.c)
            resultTypes.withUnsafeMlirStructs { resultTypes in
                mlirOperationStateAddResults(&state, resultTypes.count, resultTypes.baseAddress)
            }
            operands.withUnsafeMlirStructs { operands in
                mlirOperationStateAddOperands(&state, operands.count, operands.baseAddress)
            }
            ownedRegions.map { $0.assumeOwnership() }.withUnsafeMlirStructs { regions in
                mlirOperationStateAddOwnedRegions(&state, regions.count, regions.baseAddress)
            }
            attributes.withUnsafeMlirStructs { attributes in
                mlirOperationStateAddAttributes(&state, attributes.count, attributes.baseAddress)
            }
            return OperationReference(c: mlirOperationCreate(&state))
        }
        return Owned.assumeOwnership(of: operation)
    }
}

// MARK: - Private

private struct OperationWithPrintingOptions: MlirStringCallbackStreamable {

    struct PrintingOptions {
        var elideElementsAttributesLargerThan: Int32? = nil
        var debugInformationStyle: OperationReference.DebugInfoStyle = nil
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
