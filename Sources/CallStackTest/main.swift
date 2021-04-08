
import MLIR

let canonicalizer = CallStack.AddressCanonicalizer()
let dSYMPath = CommandLine.arguments[0] + ".dSYM"
print(dSYMPath)
let symbolicator = try! CallStack.AddressSymbolicator(dSYM: dSYMPath)

struct Foo {
  func foo() {
    print("\nFoo!")
    for (offset, frame) in CallStack()!.enumerated() {
      let canonical = canonicalizer.canonicalize(frame.instructionPointer!)!
      print("""
        \(offset): \(frame.instructionPointer!) (\(canonical))
        """)
      symbolicator.lookup(canonical)
    }
  }
}

func + (lhs: Foo, rhs: Foo) {
  lhs.foo()
  rhs.foo()
}

Foo() + Foo()

print("Done.")
