
/**
 A Swift type which is memory-layout-compatible with the MLIR type it represents
 */
protocol MlirRepresentable {
  associatedtype MlirRepresentation
  var mlir: MlirRepresentation { get }
}

extension MlirRepresentable {
  fileprivate static func validateMemoryLayout() {
    let swift = MemoryLayout<Self>.self
    let c = MemoryLayout<MlirRepresentation>.self
    precondition((swift.size, swift.stride) == (c.size, c.stride))
    precondition(!(self is AnyObject.Type))
  }
}

extension Array where Element: MlirRepresentable {
  func withUnsafeMlirRepresentation<R>(
    _ body: (UnsafeBufferPointer<Element.MlirRepresentation>) throws -> R
  ) rethrows -> R {
    Element.validateMemoryLayout()
    return try withUnsafeBufferPointer { buffer in
      try buffer.withMemoryRebound(to: Element.MlirRepresentation.self, body)
    }
  }
}
