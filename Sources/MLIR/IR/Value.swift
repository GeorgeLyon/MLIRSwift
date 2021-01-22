import CMLIR

@dynamicMemberLookup
public struct Value: OpaqueStorageRepresentable {
  let storage: BridgingStorage<MlirValue, OwnedByMLIR>

  public subscript<T>(dynamicMember keyPath: KeyPath<_MLIRValue<T>, Type<T>>) -> Type<T> {
    _MLIRValue(value: self)[keyPath: keyPath]
  }

  /// Implementation detail enabling going from a non-generic value to a generic type
  public struct _MLIRValue<MLIR: MLIRConfiguration> {
    public var type: MLIR.`Type` {
      .borrow(mlirValueGetType(.borrow(value)))!
    }
    fileprivate let value: Value
  }
}

extension MlirValue: Bridged {}
