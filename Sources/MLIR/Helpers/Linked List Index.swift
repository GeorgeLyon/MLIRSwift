extension Collection where Index == LinkedListIndex<Self> {
  public subscript(position: Index) -> Element {
    position.value!.element
  }
}

/**
 An index for linked-list-style MLIR collections
 */
public struct LinkedListIndex<Collection: Swift.Collection>: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.value, rhs.value) {
    case (.none, .none): return false
    case (.none, .some): return false
    case (.some, .none): return true
    case let (lhs?, rhs?): return lhs.offset < rhs.offset
    }
  }
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.value?.offset == rhs.value?.offset
  }
  fileprivate let value: (offset: Int, element: Collection.Element)?
}

extension LinkedListIndex
where
  Collection.Element: MlirRepresentable
{
  typealias MlirElement = Collection.Element.MlirRepresentation
  static func starting(with element: MlirElement) -> Self {
    guard let element = Collection.Element(checkingForNull: element) else {
      return .end
    }
    return Self(value: (0, element))
  }
  static var end: Self { Self(value: nil) }
  func successor(using fn: (MlirElement) -> MlirElement) -> Self {
    guard let value = value else {
      assertionFailure()
      return Self(value: nil)
    }
    guard let element = Collection.Element(checkingForNull: fn(value.element.mlir)) else {
      return .end
    }
    let offset = value.offset + 1
    return Self(value: (offset, element))
  }
}
