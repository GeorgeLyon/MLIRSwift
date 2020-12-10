import CMLIR

/**
 This file contains some convenience methods for bridging linked-list style MLIR datastructures (like the operations in a block) as a Swift `Collection`. We accepted a bit of extra complexity here so that types can define their own opqaue `Iterator` type to hide this implementation detail. This is used to implement the `Operations` type on `Block`.
 */

protocol LinkedList {
  associatedtype BridgedElement: Bridged
  where
    BridgedElement: Equatable,
    BridgedElement.IsNull == (BridgedElement) -> Bool
  associatedtype Element
  where
    Element: OpaqueStorageRepresentable,
    Element.Storage == BridgingStorage<BridgedElement, OwnedByMLIR>
  associatedtype Index: OpaqueStorageRepresentable
  where
    Index.Storage == LinkedListIndexStorage<BridgedElement>
  var first: BridgedElement { get }
  static var next: (BridgedElement) -> BridgedElement { get }
}

extension LinkedList {
  public var startIndex: Index {
    Index(storage: LinkedListIndexStorage(value: (offset: 0, element: first)))
  }
  public var endIndex: Index {
    Index(storage: LinkedListIndexStorage(value: nil))
  }
  public func index(after i: Index) -> Index {
    guard let value = i.storage.value else { return endIndex }
    let element = Self.next(value.element)
    guard !element.isNull else { return endIndex }
    return Index(storage: LinkedListIndexStorage(value: (value.offset + 1, element)))
  }
  public subscript(_ index: Index) -> Element {
    get { .borrow(index.storage.value!.element)! }
  }
}

struct LinkedListIndexStorage<Element: Bridged & Equatable>: Comparable {
  static func <(lhs: Self, rhs: Self) -> Bool {
    switch (lhs.value?.offset, rhs.value?.offset) {
    case let (lhs?, rhs?): return lhs < rhs
    case (.some, .none): return true
    default: return false
    }
  }
  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.value?.element == rhs.value?.element
  }
  fileprivate let value: (offset: Int, element: Element)?
}
