
/**
 A collection which is a member of a particular type. For instance, the arguments to a `Block` are represented as an `Arguments` type, which conforms to `MemberCollection`. This is mainly used in the `TypeList` machinery.
 */
public protocol MemberCollection: Collection {
  associatedtype Base
  static var keyPath: KeyPath<Base, Self> { get }
}
