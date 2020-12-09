
public struct Owned {
  
}

public final class Unowned {
  init<T>(_ value: T, destructor: @escaping (T) -> Void) {
  }
  let value
}

