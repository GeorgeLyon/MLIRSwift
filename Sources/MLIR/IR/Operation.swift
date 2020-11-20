
import CMLIR

public struct Operation: MlirTypeWrapper, MlirStringCallbackStreamable {
    
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
    
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirOperationPrint(c, unsafeCallback, userData)
    }
    let c: MlirOperation
}

// MARK: - Private

private struct OperationWithPrintingOptions: MlirStringCallbackStreamable {

    struct PrintingOptions {
        var elideElementsAttributesLargerThan: Int32? = nil
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
