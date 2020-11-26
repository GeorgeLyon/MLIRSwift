
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
  func withUnsafeMlirStructs<T>(_ body: (UnsafeBufferPointer<Element.MlirStruct>) throws -> T) rethrows -> T {
    precondition(MemoryLayout<Element>.size == MemoryLayout<Element.MlirStruct>.size)
    precondition(MemoryLayout<Element>.stride == MemoryLayout<Element.MlirStruct>.stride)
    return try withUnsafeBufferPointer { buffer in
      try buffer.withMemoryRebound(to: Element.MlirStruct.self, body)
    }
  }
}
