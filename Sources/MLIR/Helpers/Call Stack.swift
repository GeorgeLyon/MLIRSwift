
import CMLIR

import Darwin
import Foundation
import MachO.dyld

// MARK: - Call Stack

public struct CallStack: Sequence {
  
  public init?() {
    var context = unw_context_t()
    guard unw_getcontext(&context) == 0 else {
      return nil
    }
    self.context = context
  }
  private var context: unw_context_t
  
  public struct Frame {
    
    /**
     A memory address.
     
     - note: We don't use `UnsafeRawPointer` because we may still need to do integer arithemtic on the value (for instance, subtrating the image slide).
     */
    public struct Address: CustomStringConvertible {
      public var description: String {
        let unpadded = String(value, radix: 16)
        precondition(unpadded.count <= 16)
        return "0x\(String(repeating: "0", count: 16 - unpadded.count))\(unpadded)"
      }
      
      fileprivate var rawPointer: UnsafeRawPointer? {
        UnsafeRawPointer(bitPattern: value)
      }
      fileprivate let value: UInt
    }
    
    /**
     - note: The instruction pointer is sometimes referred to as the program counter
     - returns: `nil` if we were unable to access the instruction pointer
     */
    public var instructionPointer: Address? {
      return withoutActuallyModifying(cursor) { cursor in
        var word = unw_word_t()
        guard unw_get_reg(&cursor, unw_regnum_t(UNW_REG_IP), &word) == 0 else {
          return nil
        }
        return Address(value: word)
      }
    }
    fileprivate let cursor: unw_cursor_t
    
    /**
     - returns: the name of the procedure that created this stack frame and the byte-offset of the instruction pointer relative to the start of the procedure
     */
    public var nameAndOffset: (name: String, offset: UInt)? {
      withoutActuallyModifying(cursor) { cursor in
        var succeeded = false
        var offset = unw_word_t()
        let name = String(
          unsafeUninitializedCapacity: 1 << 10,
          initializingUTF8With: { buffer in
            buffer.withMemoryRebound(to: Int8.self) { buffer in
              guard unw_get_proc_name(&cursor, buffer.baseAddress, buffer.count, &offset) == 0 else {
                return 0
              }
              succeeded = true
              return strnlen(buffer.baseAddress!, buffer.count)
            }
          })
        guard succeeded else { return nil }
        return (name, UInt(offset))
      }
    }
  }
  
  public func makeIterator() -> Iterator {
    var cursor = unw_cursor_t()
    /// The following operation should not modify the context
    var context = self.context
    let result = unw_init_local(&cursor, &context)
    precondition(result == 0)
    return Iterator(cursor: cursor)
  }
  public struct Iterator: IteratorProtocol {
    public mutating func next() -> Frame? {
      guard !isAtEnd else { return nil }
      
      let result = unw_step(&cursor)
      if result < 0 {
        fatalError()
      } else {
        isAtEnd = result == 0
      }
      return Frame(cursor: cursor)
    }
    
    var isAtEnd: Bool = false
    var cursor: unw_cursor_t
  }
  
}

// MARK: - Canonical Addresses

extension CallStack {
  
  /**
   A type responsible for calculating canonical (pre ASLR) addresses
   */
  public struct AddressCanonicalizer {
    
    /**
     `AddressCanonicalizer` takes a snapshot of the process when it is created. Certain operations, such as loading or unloading shared libaries, can invalidate this snapshot (and require recreation of the `AddressCanonicalizer`).
     */
    public init() {
      imageSlides = Dictionary(
          uniqueKeysWithValues:
            (0..<_dyld_image_count())
              .map { image in
                let name = String(cString: _dyld_get_image_name(image))
                let slide = UInt(_dyld_get_image_vmaddr_slide(image))
                return (name, slide)
              })
    }
    
    /**
     - returns: the canonical (pre ASLR) version of the provided address
     */
    public func canonicalize(_ address: Frame.Address) -> Frame.Address? {
      var info = Dl_info()
      guard
        let pointer = address.rawPointer,
        dladdr(pointer, &info) > 0,
        let slide = imageSlides[String(cString: info.dli_fname)]
      else {
        return nil
      }
      return Frame.Address(value: address.value - slide)
    }
    
    private let imageSlides: [String: UInt]
  }
  
}

// MARK: - Symbolication

extension CallStack {
  /**
   A type which can symbolicate a canonical (pre ASLR) address using debug symbols.
   */
  public final class AddressSymbolicator {
    
    let container: LLVMDWARFContainerRef
    
    /**
     - warning: This method synchronously read files from disk
     */
    public init(dSYM path: String) throws {
      container = path.withCString(LLVMDWARFContainerCreate)
    }
    
    public func lookup(_ address: Frame.Address) {
      LLVMDWARFContainerLookup(
        container,
        { (file, line, column, userData) in
          print(" - \(file.string):\(line):\(column)")
        },
        UInt64(address.value),
        nil)
    }
  }
}

// MARK: - Helpers

private func withoutActuallyModifying<T, U>(_ value: T, body: (inout T) -> U) -> U {
  var mutableValue = value
  let result = body(&mutableValue)
  withUnsafeBytes(of: mutableValue) { bytes in
    withUnsafeBytes(of: value) { originalBytes in
      precondition(bytes.elementsEqual(originalBytes))
    }
  }
  return result
}
