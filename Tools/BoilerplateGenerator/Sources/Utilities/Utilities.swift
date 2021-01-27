
import Foundation

private var indentation = 0

let preamble: Void = {
  let executable = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
  print("""

  /**
   This file was autogenerated by running `Tools/generate-boilerplate`
   */

  """)
}()

prefix operator <<
public prefix func <<(_ next: String) {
  preamble
  print(next.components(separatedBy: "\n")
    .map { String(repeating: "  ", count: indentation) + $0 }
    .joined(separator: "\n"))
}

public func increaseIndentation() {
  indentation += 1
}

public func decreaseIndentation() {
  indentation -= 1
}

