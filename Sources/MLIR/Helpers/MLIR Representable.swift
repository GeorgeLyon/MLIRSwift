/**
 A Swift struct which is memory-layout-compatible with an MLIR type represented by a single pointer.
 */
protocol MlirRepresentable {
  associatedtype MlirRepresentation
  var mlir: MlirRepresentation { get }
}

extension MlirRepresentable {
  /**
   Initializes this type by casting directly from its MLIR representation.

   - precondition: `mlir` must not be `nil`
   */
  public init(_ mlir: MlirRepresentation) {
    self.init(checkingForNull: mlir)!
  }

  /**
   Initializes this type by casting directly from its MLIR representation if non-`nil`
   */
  public init?(checkingForNull mlir: MlirRepresentation) {
    Self.validateMemoryLayout()
    let optionalValue = withUnsafePointer(to: mlir) { pointer -> Self? in
      let raw = UnsafeRawPointer(pointer)
      if raw.assumingMemoryBound(to: MlirPointer.self).pointee == nil {
        return nil
      } else {
        return raw.assumingMemoryBound(to: Self.self).pointee
      }
    }
    guard let value = optionalValue else { return nil }
    self = value
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

// MARK: - Private

extension MlirRepresentable {
  fileprivate static func validateMemoryLayout() {
    precondition(isMemoryLayoutCompatible(with: MlirRepresentation.self))
    precondition(isMemoryLayoutCompatible(with: MlirPointer.self))
    precondition(!(Self.self is AnyObject.Type))
  }
}

private extension MlirRepresentable {
  private static func isMemoryLayoutCompatible<T>(with other: T.Type) -> Bool {
    [
      (MemoryLayout<Self>.size, MemoryLayout<T>.size),
      (MemoryLayout<Self>.stride, MemoryLayout<T>.stride),
      (MemoryLayout<Self>.alignment, MemoryLayout<T>.alignment),
    ]
    .allSatisfy(==)
  }
}

private typealias MlirPointer = UnsafeMutableRawPointer?
