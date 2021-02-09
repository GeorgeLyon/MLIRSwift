
import CMLIR

/**
 - precondition: Conforming types **must** have exactly 1 stored property, and the type of that property must be `CRepresentation`
 */
protocol CRepresentable {
  associatedtype CRepresentation
  var c: CRepresentation { get }
  
  /**
   We use this forumlation rather than a refinement protocol because we want to be able to express non-nullable types, and one cannot write `T != Nullable` in a `where` clause, but one can write `IsNull == Void`.
   */
  associatedtype IsNull = Void
  static var isNull: IsNull { get }
}

// MARK: - Initialization

extension CRepresentable where IsNull == Void {
  static var isNull: Void { () }
  init(c: CRepresentation) {
    precondition(Self.isMemoryLayoutCompatibleWithCRepresentation)
    self = withUnsafePointer(to: c) {
      $0.withMemoryRebound(to: Self.self, capacity: 1) {
        $0.pointee
      }
    }
  }
}

extension CRepresentable where IsNull == (CRepresentation) -> Bool {
  init?(c: CRepresentation) {
    precondition(Self.isMemoryLayoutCompatibleWithCRepresentation)
    guard !Self.isNull(c) else { return nil }
    self = withUnsafePointer(to: c) {
      $0.withMemoryRebound(to: Self.self, capacity: 1) {
        $0.pointee
      }
    }
  }
}

// MARK: - Arrays

extension Array where Element: CRepresentable {
  func withUnsafeCRepresentation<R>(_ body: (UnsafeBufferPointer<Element.CRepresentation>) throws -> R) rethrows -> R
  {
    precondition(Element.isMemoryLayoutCompatibleWithCRepresentation)
    return try withUnsafeBufferPointer { buffer in
      try buffer.withMemoryRebound(to: Element.CRepresentation.self, body)
    }
  }
}

// MARK: - Private

extension CRepresentable {
  fileprivate static var isMemoryLayoutCompatibleWithCRepresentation: Bool {
    let swiftLayout = MemoryLayout<Self>.self
    let cLayout = MemoryLayout<CRepresentation>.self
    return (swiftLayout.size, swiftLayout.stride) == (cLayout.size, cLayout.stride)
  }
}
