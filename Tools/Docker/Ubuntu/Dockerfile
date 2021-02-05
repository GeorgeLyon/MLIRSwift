
# Builds a docker image which can be used to test this project on Linux
# Example use:
# $ docker build -t mlir-swift Tools/Docker/Ubuntu
# $ docker run --rm -ti -v $PWD:/wd -w /wd mlir-swift

FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y git
RUN apt-get install -y cmake ninja-build
RUN apt-get install -y clang libpython2.7 libpython2.7-dev wget
RUN wget https://swift.org/builds/swift-5.3-release/ubuntu2004/swift-5.3-RELEASE/swift-5.3-RELEASE-ubuntu20.04.tar.gz
RUN tar xzf swift-5.3-RELEASE-ubuntu20.04.tar.gz
ENV PATH="/swift-5.3-RELEASE-ubuntu20.04/usr/bin:${PATH}"
ENV PKG_CONFIG_PATH="/root/.dependencies/installed"
RUN swift --version
