import CMLIR

public struct Location: MlirRepresentable {

  /**
   Creates a location owned by `context` with the provided file, line and column
   */
  public static func file(_ file: StaticString, line: UInt, column: UInt, in context: Context)
    -> Location
  {
    file.withUnsafeMlirStringRef {
      Location(
        mlirLocationFileLineColGet(
          context.mlir,
          $0,
          UInt32(line),
          UInt32(column)))
    }
  }

  /**
   Creates an unknown location owned by the provided context
   */
  public static func unknown(in context: Context) -> Location {
    Location(mlirLocationUnknownGet(context.mlir))
  }

  /**
   Creates a call site location with `self` as the callee and `callSite` as the caller
   */
  public func called(from callSite: Location) -> Location {
    Location(mlirLocationCallSiteGet(mlir, callSite.mlir))
  }

  /**
   Creates a call site location with `self` as the callee and the current source location as the caller
   */
  public func viaCallsite(
    file: StaticString = #fileID, line: UInt = #line, column: UInt = #column
  ) -> Location {
    Location.file(file, line: line, column: column, in: context)
      .called(from: self)
  }

  /**
   The `context` associated with this location
   */
  public var context: UnownedContext {
    UnownedContext(mlirLocationGetContext(mlir))
  }

  public init(_ mlir: MlirLocation) {
    self.init(mlir: mlir)
  }
  public let mlir: MlirLocation
}

/// For some reason, declaring this conformance in `Text Output Stream.swift` (like all the others) crashes the Swift 5.3 compiler.
extension Location: Printable {
  static let print = mlirLocationPrint
}
