
/**
 A protocol providing convenience APIs for Swift types which wrap an underlying C type.
 */
protocol MlirStructWrapper {
  /**
   The type being wrapped
   */
  associatedtype MlirStruct
  
  init(c: MlirStruct)
  var c: MlirStruct { get }
}

extension Array where Element: MlirStructWrapper {
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
