# This project should only be built via LLVM_EXTERNAL_PROJECTS
# See `build-dependencies` for more details

cmake_minimum_required(VERSION 3.13.4)
project(SimpleProject)

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

file(GLOB sources *.cpp)
add_llvm_library(MLIRSwiftSupport
    ${sources}
    
    LINK_LIBS PUBLIC
    DebugInfoDWARF)

# add_executable(MLIRSwiftSupport tool.cpp)

# Find the libraries that correspond to the LLVM components
# that we wish to use
# llvm_map_components_to_libnames(llvm_libs support Core IRReader DebugInfoDWARF)

# Link against LLVM libraries
# target_link_libraries(MLIRSwiftSupport ${llvm_libs})