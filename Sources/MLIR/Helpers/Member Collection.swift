
public protocol MemberCollection: Collection {
    associatedtype Base
    static var keyPath: KeyPath<Base, Self> { get }
}
