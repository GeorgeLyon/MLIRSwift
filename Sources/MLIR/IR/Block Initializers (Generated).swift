/// This file was autogenerated by running `Tools/generate-boilerplate`

extension Block {

  /// 0 arguments
  public init(
    buildOperations: (Block.Operations) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [])
    try buildOperations(operations)
  }

  /// 1 arguments
  public init(
    _ t0: Type,
    buildOperations: (Block.Operations, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0])
    try buildOperations(operations, arguments[0])
  }

  /// 1 arguments, contentual types
  public init(
    _ t0: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0], in: context)
    try buildOperations(operations, arguments[0])
  }

  /// 2 arguments
  public init(
    _ t0: Type, _ t1: Type,
    buildOperations: (Block.Operations, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1])
    try buildOperations(operations, arguments[0], arguments[1])
  }

  /// 2 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1], in: context)
    try buildOperations(operations, arguments[0], arguments[1])
  }

  /// 3 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type,
    buildOperations: (Block.Operations, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2])
    try buildOperations(operations, arguments[0], arguments[1], arguments[2])
  }

  /// 3 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2], in: context)
    try buildOperations(operations, arguments[0], arguments[1], arguments[2])
  }

  /// 4 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type,
    buildOperations: (Block.Operations, Value, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3])
    try buildOperations(operations, arguments[0], arguments[1], arguments[2], arguments[3])
  }

  /// 4 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3], in: context)
    try buildOperations(operations, arguments[0], arguments[1], arguments[2], arguments[3])
  }

  /// 5 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4])
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4])
  }

  /// 5 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    _ t4: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4], in: context)
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4])
  }

  /// 6 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5])
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]
    )
  }

  /// 6 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    _ t4: ContextualType, _ t5: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value, Value) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5], in: context)
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]
    )
  }

  /// 7 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value, Value, Value) throws ->
      Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6])
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6])
  }

  /// 7 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    _ t4: ContextualType, _ t5: ContextualType, _ t6: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value, Value, Value) throws ->
      Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6], in: context)
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6])
  }

  /// 8 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type, _ t7: Type,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value, Value, Value, Value)
      throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6, t7])
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7])
  }

  /// 8 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    _ t4: ContextualType, _ t5: ContextualType, _ t6: ContextualType, _ t7: ContextualType,
    in context: Context,
    buildOperations: (Block.Operations, Value, Value, Value, Value, Value, Value, Value, Value)
      throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6, t7], in: context)
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7])
  }

  /// 9 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type, _ t7: Type,
    _ t8: Type,
    buildOperations: (
      Block.Operations, Value, Value, Value, Value, Value, Value, Value, Value, Value
    ) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6, t7, t8])
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7], arguments[8])
  }

  /// 9 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    _ t4: ContextualType, _ t5: ContextualType, _ t6: ContextualType, _ t7: ContextualType,
    _ t8: ContextualType,
    in context: Context,
    buildOperations: (
      Block.Operations, Value, Value, Value, Value, Value, Value, Value, Value, Value
    ) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6, t7, t8], in: context)
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7], arguments[8])
  }

  /// 10 arguments
  public init(
    _ t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type, _ t7: Type,
    _ t8: Type, _ t9: Type,
    buildOperations: (
      Block.Operations, Value, Value, Value, Value, Value, Value, Value, Value, Value, Value
    ) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9])
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7], arguments[8], arguments[9])
  }

  /// 10 arguments, contentual types
  public init(
    _ t0: ContextualType, _ t1: ContextualType, _ t2: ContextualType, _ t3: ContextualType,
    _ t4: ContextualType, _ t5: ContextualType, _ t6: ContextualType, _ t7: ContextualType,
    _ t8: ContextualType, _ t9: ContextualType,
    in context: Context,
    buildOperations: (
      Block.Operations, Value, Value, Value, Value, Value, Value, Value, Value, Value, Value
    ) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9], in: context)
    try buildOperations(
      operations, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7], arguments[8], arguments[9])
  }

}
