import CMLIR

/**
 This file contains some convenience methods for bridging linked-list style MLIR datastructures (like the operations in a block) as a Swift `Collection`. We accepted a bit of extra complexity here so that types can define their own opqaue `Iterator` type to hide this implementation detail. This is used to implement the `Operations` type on `Block`.
 */

protocol LinkedList {
  associatedtype Element: Bridged where Element.Ownership == OwnedByMLIR
  associatedtype Index: LinkedListIndex where Index.Element == Element.MlirStruct
  var first: Element.MlirStruct { get }
}

extension LinkedList {
  public var startIndex: Index { .start(first) }
  public var endIndex: Index { .end }
  public func index(after i: Index) -> Index { i.next }
  public subscript(position: Index) -> Element {
    get { Element(borrowing: position.cursor.value!.element)! }
  }
}

protocol LinkedListIndex: Comparable {
  associatedtype Element: Bridgable
  init(cursor: LinkedListCursor<Element>)
  var cursor: LinkedListCursor<Element> { get }
  static var next: (Element) -> Element { get }
}

extension LinkedListIndex {
  public static func <(lhs: Self, rhs: Self) -> Bool {
    lhs.cursor < rhs.cursor
  }
  fileprivate static func start(_ element: Element?) -> Self {
    Self(cursor: LinkedListCursor(value: element.map{(0, $0)}))
  }
  fileprivate static var end: Self {
    Self(cursor: LinkedListCursor(value: nil))
  }
  fileprivate var next: Self {
    guard let value = cursor.value else { return .end }
    let element = Self.next(value.element)
    guard !element.isNull else { return .end }
    return Self(cursor: LinkedListCursor(value: (offset: value.offset + 1, element: element)))
  }
}

struct LinkedListCursor<Element: Equatable>: Comparable {
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
