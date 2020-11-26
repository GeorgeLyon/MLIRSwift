
protocol BuilderProtocol {
    associatedtype Product
    init(producer: Producer<Self.Product>)
}

extension BuilderProtocol {
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
