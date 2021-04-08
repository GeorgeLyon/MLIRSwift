# This project is meant to compile as part of the LLVM build using LLVM_EXTERNAL_PROJECTS
# See `build-dependencies` for more details

cmake_minimum_required(VERSION 3.13.4)
project(SimpleProject)

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

set(MLIR_MAIN_SRC_DIR ${LLVM_MAIN_SRC_DIR}/../mlir )
set(MLIR_INCLUDE_DIR ${MLIR_MAIN_SRC_DIR}/include )
include_directories(SYSTEM ${MLIR_INCLUDE_DIR})

# Sources
llvm_map_components_to_libnames(llvm_component_libs DebugInfoDWARF)
file(GLOB sources *.cpp)
add_llvm_library(MLIRSwiftSupport
    ${sources}
    
    LINK_LIBS PUBLIC
    MLIRCAPI
    ${llvm_component_libs})
    
# Headers
add_custom_target(MLIRSwiftSupport-headers)
set_target_properties(MLIRSwiftSupport-headers PROPERTIES FOLDER "Misc")
install(FILES 
    MLIRSwiftSupport.h
    DESTINATION include/MLIRSwiftSupport
    COMPONENT MLIRSwiftSupport-headers)
add_llvm_install_targets(install-MLIRSwiftSupport-headers
    DEPENDS MLIRSwiftSupport-headers
    COMPONENT MLIRSwiftSupport-headers)