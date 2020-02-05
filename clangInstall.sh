#! /usr/bin/env bash

#load some modules

module purge
module load gcc/8.3.1
module load git
module load cmake

#set up directories
mkdir -p llvm
cd llvm
mkdir -p install

#if we've not already cloned here, get the source
if [ ! -d llvm-project ] ; then
  git clone https://github.com/llvm/llvm-project.git
fi

#set up some more directories
cd llvm-project
git checkout -b release/10.x origin/release/10.x

mkdir -p build-$(uname -p)
cd build-$(uname -p)

#configure llvm to build a release with clang using gcc
cmake CXX=g++ CC=gcc  -G "Unix Makefiles" \
	-DLLVM_CXX_STD:STRING=c++17  \
	-DCMAKE_USE_RELATIVE_PATHS:BOOL=OFF \
	-DLLVM_ENABLE_PROJECTS="clang;compiler-rt" \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_INSTALL_PREFIX=../../install/$(uname -p) \
	../llvm

#build then install
make -j40
make install
