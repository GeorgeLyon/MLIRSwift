# MLIR Bindings for Swift

This project intends to make MLIR APIs accessible from Swift via the MLIR C Bindings.

**DISCLAIMER:** This project is a work in progress, expect things to be incomplete and to change without notice. As such, we recommend tracking the `main` branch in your dependent project:
```
dependencies: [
  .package(name: "MLIR", url: "https://github.com/GeorgeLyon/MLIRSwift", .branch("main"))
],
```

## Usage

The best reference for how to use this package will always be the tests ([Module Tests](Tests/DialectTests/Module%20Tests.swift) is probably the most interesting), and I recommend consulting them for more details.

## MLIR

### Installation

MLIR is build using the LLVM build infrastructure which uses `cmake`. This is incompatible with Swift Package Manager, so for now developers will need to install MLIR separately in order for this project to work. Once the MLIR C API settles and Swift Package Manager get better support for binary targets on Linux, we will likely make this dependency available as a precompiled binary. 

In the meantime, you can manually install MLIR using the `Tools/build-dependencies` script

### Updating

We do not include MLIR (llvm) as a submodule, because this would cause Swift Pacakge Manager to pull in all of LLVM in any project depending on MLIRSwift. Instead, we store the hash we care about in `Tools/llvm-commit` file, update this file to a new commit to update MLIR. Note that this file _must_ be a hash and not a branch like `main`, since the contents of this file is used to cache the LLVM build on GitHub Actions. 

**NOTE**

### Using an external MLIR checkout

You can point use your own local version of MLIR in a number of ways, the most flexible is simply to install a custom "LLVM-for-Swift.pc" file that points to your locally built version (consult `Tools/build-dependencies` for an example). A simpler option may be to run `Tools/build-dependencies` with the environment variable `LLVM_REPO` set to `""`, and `LLVM_REPO_PATH` set to the path to the repo you want to use. There are a number of other knobs you can turn in `Tools/build-dependencies` to customize this approach.

## Design



