
import CMLIR

public struct Location: CRepresentable {
  public init(context: Context, file: StaticString, line: Int, column: Int) {
    c = file.withUnsafeMlirStringRef {
      mlirLocationFileLineColGet(context.c, $0, UInt32(line), UInt32(column))
    }
  }
  let c: MlirLocation
}
