
import CMLIR

public struct Location {
  init(c: MlirLocation) {
    self.c = c
  }
  let c: MlirLocation
}

extension MLIRConfiguration {
  static func location(file: StaticString, line: Int, column: Int) -> Location {
    precondition(file.hasPointerRepresentation)
    return Location(c: file.withUnsafeMlirStringRef {
      mlirLocationFileLineColGet(ctx, $0, UInt32(line), UInt32(column))
    })
  }
}
