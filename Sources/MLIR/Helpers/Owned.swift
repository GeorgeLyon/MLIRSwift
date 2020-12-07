
/**
 A type that owns an instance of `Value`. Certain API in the bindings will "take ownership" of an `Owned`, meaning that every `Owned` value can be passed to at most 1 such API.
 */
public final class Owned<Value> {
  
  func consume() -> Value {
    precondition(!isOwned)
    isOwned = false
    return value
  }
  
  private typealias Destroyer = (Value) -> Void
  private init(value: Value, destroy: @escaping Destroyer) {
    self.value = value
    self.destroy = destroy
  }
  deinit {
    if isOwned { destroy(value) }
  }
  private var isOwned = true
  private var value: Value
  private let destroy: Destroyer
}

// MARK: - Internal

protocol Destroyable {
  func destroy()
}

extension Owned {
  convenience init(_ value: Value) where Value: Destroyable {
    self.init(value: value, destroy: { $0.destroy() })
  }
  
  convenience init<Element: Destroyable>(_ value: Value) where Value == [Element] {
    self.init(value: value, destroy: { $0.forEach { $0.destroy() } })
  }
  
  func append<Element: Destroyable>(_ element: Element) where Value == [Element] {
    precondition(isOwned)
    value.append(element)
  }
}
