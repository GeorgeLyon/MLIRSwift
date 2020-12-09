
import CMLIR

public struct Location: OpaqueStorageRepresentable {
  let storage: BridgingStorage<MlirLocation, OwnedByMLIR>
}

extension MlirLocation: Bridged {
  
}

extension MLIRConfiguration {
  static func location(file: StaticString, line: Int, column: Int) -> Location {
    precondition(file.hasPointerRepresentation)
    return .borrow(file.withUnsafeMlirStringRef {
      mlirLocationFileLineColGet(ctx, $0, UInt32(line), UInt32(column))
    })
  }
}
