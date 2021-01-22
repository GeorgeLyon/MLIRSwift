
protocol CEquatable: Equatable {
  static var areEqual: (Self, Self) -> Bool { get }
}

extension CEquatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    areEqual(lhs, rhs)
  }
}
