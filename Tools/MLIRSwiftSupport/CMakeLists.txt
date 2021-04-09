# This project is meant to compile as part of the LLVM build using LLVM_EXTERNAL_PROJECTS
# See `build-dependencies` for more details

cmake_minimum_required(VERSION 3.13.4)

include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${LLVM_INCLUDE_DIRS})

# Sources
file(GLOB sources *.cpp)
add_llvm_library(MLIRSwiftSupport
    ${sources}
    LINK_LIBS PUBLIC
    MLIRCAPI)
    
# Headers
add_custom_target(MLIRSwiftSupport-headers)
install(
    FILES
    # Headers listed here will be installed
    MLIRSwiftSupport.h

    DESTINATION include/MLIRSwiftSupport
    COMPONENT MLIRSwiftSupport-headers)
add_llvm_install_targets(install-MLIRSwiftSupport-headers
    DEPENDS MLIRSwiftSupport-headers
    COMPONENT MLIRSwiftSupport-headers)