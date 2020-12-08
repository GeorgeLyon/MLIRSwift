
/**
 - invariant: `MemoryLayout<OwnedByMLIR>.size` must equal 0
 */
extension Array where Element: Bridged, Element.Ownership == OwnedByMLIR {
  /**
   For arrays of types which just wrap an MLIR type (and hence have the same memory layout), this method allows you to use the underlying C types without creating a new `Array`.
   */
  func withUnsafeMlirStructs<T>(_ body: (UnsafeBufferPointer<Element.MlirStruct>) throws -> T) rethrows -> T {
    precondition(MemoryLayout<Element>.size == MemoryLayout<Element.MlirStruct>.size)
    precondition(MemoryLayout<Element>.stride == MemoryLayout<Element.MlirStruct>.stride)
    return try withUnsafeBufferPointer { buffer in
      try buffer.withMemoryRebound(to: Element.MlirStruct.self, body)
    }
  }
}
