
import Foundation

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
  print(next)
}
