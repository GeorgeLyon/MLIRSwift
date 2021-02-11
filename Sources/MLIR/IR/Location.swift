import CMLIR

public struct Location: CRepresentable, Printable {
  public init(context: Context, file: StaticString, line: Int, column: Int) {
    c = file.withUnsafeMlirStringRef {
      mlirLocationFileLineColGet(context.cRepresentation, $0, UInt32(line), UInt32(column))
    }
  }

  public static func unknown(in context: Context) -> Location {
    Location(c: mlirLocationUnknownGet(context.cRepresentation))
  }

  public func called(from location: Location) -> Location {
    Location(c: mlirLocationCallSiteGet(self.c, location.c))
  }
  public func viaCallsite(
    file: StaticString = #fileID, line: Int = #line, column: Int = #column
  ) -> Location {
    Location(context: context, file: file, line: line, column: column).called(from: self)
  }

  public var context: Context {
    Context(c: mlirLocationGetContext(c))!
  }

  let c: MlirLocation

  static let print = mlirLocationPrint
}
