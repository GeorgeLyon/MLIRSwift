

extension Array {
  
  /**
   When a Swift representation of a bridged MLIR type is `OwnedByMLIR`, their memory layouts are identical, so we can access the underlying bridge types without allocating a new array.
   */
  func withUnsafeBridgedValues<T, R>(_ body: (UnsafeBufferPointer<T>) throws -> R) rethrows -> R
  where
    T: Bridged,
    Element: OpaqueStorageRepresentable,
    Element.Storage == BridgingStorage<T, OwnedByMLIR>
  {
    precondition(MemoryLayout<Element>.size == MemoryLayout<T>.size)
    precondition(MemoryLayout<Element>.stride == MemoryLayout<T>.stride)
    return try withUnsafeBufferPointer { buffer in
      try buffer.withMemoryRebound(to: T.self, body)
    }
  }
  
}

