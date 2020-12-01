
/**
 `BuilderProtocol` defines a common interface for "Builder" types, like `Operation.Builder`, which builds some number of `Product`s. These products can be accessed using the static `products` method on the concrete builder type.
 */
protocol BuilderProtocol {
  associatedtype Product
  init(producer: Producer<Self.Product>)
}

extension BuilderProtocol {
  
  /**
   - returns: Products produced by the builder that is passed to the `body` closure.
   */
  static func products(_ body: (Self) throws -> Void) rethrows -> [Product] {
    try withoutActuallyEscaping(body) { try products(.some($0)) }
  }
  
  /**
   - returns: Products produced by the builder that is passed to the `body` closure.
   - note: `body` is passed as an `Optional` because default values for `rethrows` arguments are [always interpreted as throwing](https://forums.swift.org/t/default-values-for-arguments-that-rethrow/42406). By making these closures `Optional` we can use a default value of `nil`, which doesn't seem to trigger `rethrows` being interpreted as `throws`.
   */
  static func products(_ body: Optional<(Self) throws -> Void>) rethrows -> [Product] {
    var isComplete = false
    var products: [Product] = []
    let builder = Self(producer: Producer {
      precondition(!isComplete) /// Check that this value didn't escape
      products.append($0)
    })
    try body.flatMap { try $0(builder) }
    isComplete = true
    return products
  }
  
}

struct Producer<Product> {
  func produce(_ product: Product) {
    append(product)
  }
  fileprivate let append: (Product) -> Void
}
