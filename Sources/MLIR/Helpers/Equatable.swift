
protocol CEquatable: Equatable {
  static var areEqual: (Self, Self) -> Int32 { get }
}

extension CEquatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    areEqual(lhs, rhs) != 0
  }
}
