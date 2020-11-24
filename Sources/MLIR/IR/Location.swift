
import CMLIR

public struct Location: MlirTypeWrapper, MlirStringCallbackStreamable {
    public init<MLIR: MLIRConfiguration>(_ mlir: MLIR.Type = MLIR.self, file: StaticString, line: Int, column: Int) {
        precondition(file.hasPointerRepresentation)
        c = file.withUnsafeMlirStringRef {
            mlirLocationFileLineColGet(MLIR.context.c, $0, UInt32(line), UInt32(column))
        }
    }
    init(c: MlirLocation) {
        self.c = c
    }
    
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirLocationPrint(c, unsafeCallback, userData)
    }
    
    let c: MlirLocation
}
