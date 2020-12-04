
public extension MLIRConfiguration {
  typealias RegisteredDialect = DialectRegistry.RegisteredDialect
}

public protocol DialectRegistry {
  init()
  static var dialects: [RegisteredDialect] { get }
}

public extension DialectRegistry {
  typealias RegisteredDialect = KeyPath<Self, Dialect>
}
