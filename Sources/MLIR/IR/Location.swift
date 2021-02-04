import CMLIR

public struct Location: OpaqueStorageRepresentable {
  public init(file: StaticString = #fileID, line: Int = #line, column: Int = #column) {
    self = .borrow(
      file.withUnsafeMlirStringRef {
        mlirLocationFileLineColGet(MLIR.context, $0, UInt32(line), UInt32(column))
      })
  }
  public func called(by location: Location) -> Location {
    .borrow(mlirLocationCallSiteGet(.borrow(self), .borrow(location)))
  }
  init(storage: BridgingStorage<MlirLocation, OwnedByMLIR>) { self.storage = storage }
  let storage: BridgingStorage<MlirLocation, OwnedByMLIR>
}

extension MlirLocation: Bridged {

}
