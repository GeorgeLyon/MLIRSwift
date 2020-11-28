
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
  static func products(_ body: (Self) -> Void) -> [Product] {
    var isComplete = false
    var products: [Product] = []
    let builder = Self(producer: Producer {
      precondition(!isComplete) // Check that this value didn't escape
      products.append($0)
    })
    body(builder)
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
