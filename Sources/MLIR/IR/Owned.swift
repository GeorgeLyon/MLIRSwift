
/**
 This is a class for now, but in the future we hope to replace it with a deinitializable struct, `mustconsume` type, or something along those lines.
 */
public final class Owned<Value> {
    
    func releasingOwnership() -> Value {
        precondition(isOwned)
        isOwned = false
        return value
    }
    deinit {
        if isOwned { destroy(value)() }
    }
    
    fileprivate typealias Destroyer = (Value) -> () -> Void
    fileprivate init(value: Value, destroy: @escaping Destroyer) {
        self.value = value
        self.destroy = destroy
    }
    private let value: Value
    private let destroy: Destroyer
    private var isOwned = true
}

// MARK: - Internal

protocol Destroyable {
    func destroy()
}

extension Owned where Value: Destroyable {
    static func assumingOwnership(of value: Value) -> Owned {
        return Owned(value: value, destroy: Value.destroy)
    }
}
