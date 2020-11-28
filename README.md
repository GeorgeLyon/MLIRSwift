# MLIR Bindings for Swift

This project intends to make MLIR APIs accessible from Swift via the MLIR C Bindings. 

## Usage

The best reference for how to use this package will always be the tests, and I recommend consulting them for more details.

At a high level, you start by creating an `MLIRConfiguration` (lets call it `MyMLIR`), which involves creating an `MLIRContext` with the dialects you want enabled. Once you have this configuration, you can create a `MyMLIR.Module`.

## Installing MLIR

MLIR is build using the LLVM build infrastructure which uses `cmake`. This is incompatible with Swift Package Manager, so for now developers will need to install MLIR separately in order for this project to work. Once the MLIR C API settles and Swift Package Manager get better support for binary targets on Linux, we will likely make this dependency available as a precompiled binary. 

In the meantime, you can manually install MLIR using the following steps:
```
$ git clone https://github.com/llvm/llvm-project
$ mkdir llvm-project/build
$ cd llvm-project build
$ cmake -G Ninja ../llvm \
  -DCMAKE_INSTALL_PREFIX=<where-you-want-to-install-MLIR> \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_TARGETS_TO_BUILD=host
$ ninja check-mlir
$ ninja $(<path-to-this-repo>/Utilities/mlir-install-targets)
```

You also need to install the `Resources/MLIR.pc` file to `/usr/local/lib/pkgconfig/MLIR.pc`, and change the `prefix` value in that file to the value you provided for `CMAKE_INSTALL_PREFIX` above.
