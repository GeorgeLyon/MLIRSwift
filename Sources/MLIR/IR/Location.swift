
import CMLIR

public struct Location: MlirStructWrapper, MlirStringCallbackStreamable {
  init(c: MlirLocation) {
    self.c = c
  }
  
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirLocationPrint(c, unsafeCallback, userData)
  }
  
  let c: MlirLocation
}

extension MLIRConfiguration {
  static func location(file: StaticString, line: Int, column: Int) -> Location {
    precondition(file.hasPointerRepresentation)
    return Location(c: file.withUnsafeMlirStringRef {
      mlirLocationFileLineColGet(context.c, $0, UInt32(line), UInt32(column))
    })
  }
}
