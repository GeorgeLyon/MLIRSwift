
import CMLIR

public struct Location: OpaqueStorageRepresentable {
  init(_ ctx: MlirContext, file: StaticString, line: Int, column: Int) {
    self = .borrow(file.withUnsafeMlirStringRef {
      mlirLocationFileLineColGet(ctx, $0, UInt32(line), UInt32(column))
    })
  }
  /**
   Creates a call site location
   - note: This currently just returns `self` but will eventually do something once `CallSiteLoc` is bridged
   */
  func called(by location: Location) -> Location {
    return self
  }
  init(storage: BridgingStorage<MlirLocation, OwnedByMLIR>) { self.storage = storage }
  let storage: BridgingStorage<MlirLocation, OwnedByMLIR>
}

extension MlirLocation: Bridged {
  
}
