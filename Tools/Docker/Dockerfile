
# Builds a docker image which can be used to test this project on Linux
# Example use:
# $ docker build -t mlir-swift Tools/Docker
# $ docker run --rm -ti -v $(pwd):/project -w /project mlir-swift

# You can also build an image with the nightly toolchain like so:
# $ docker build -t mlir-swift Tools/Docker --build-arg image=swiftlang/swift:nightly-focal

ARG image=swift:focal
FROM $image

RUN apt-get update && apt-get upgrade -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y git
RUN apt-get install -y libncurses5-dev libncursesw5-dev
RUN apt-get install -y cmake ninja-build python3
ENV DEPENDENCIES_ROOT="/project/.dependencies/linux"
ENV LLVM_REPO_PATH="/project/.dependencies/llvm-repo"
ENV PKG_CONFIG_PATH="$DEPENDENCIES_ROOT/installed"
RUN swift --version
