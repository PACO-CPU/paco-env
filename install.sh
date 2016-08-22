#!/bin/bash
#
# Script to build PACO enviroment
#

ENV_PATH=`pwd`
JOBS=4

if [ "x$RISCV" = "x" ]
then 
    echo "RISCV variable not found. Getting it friom $ENV_PATH/env.sh"
    . $ENV_PATH/env.sh
fi 

# Build RISCV toolchain first
echo "Building RISCV toolchain ... "
cd $ENV_PATH/riscv-tools-src/
echo ". build.sh"

# Build LLVM 
echo "Building LLVM ... "
mkdir -p $ENV_PATH/riscv-tools-src/riscv-llvm/build
cd $ENV_PATH/riscv-tools-src/riscv-llvm/build
if [ -f config.log ]
then
    read -p "LLVM was already configured. Configure again?[Y/n]" yn
    case $yn in
        [Yy]* ) echo "CC=gcc CXX=g++ ../configure --enable-target=riscv --prefix=$RISCV > build.log" break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
else 
    echo "CC=gcc CXX=g++ ../configure --enable-target=riscv --prefix=$RISCV > build.log"
fi 

echo "make -j$JOBS LDFLAGS=-luuid >> build.log"
echo "make install >> build.log"

# Build LUT-compiler
echo "Building LUT-compiler ... "
cd $ENV_PATH/riscv-tools-src/
echo "make -j$JOBS && make install > build.log"

# Installing python libs
echo "Installing python libs ..."
cd $ENV_PATH/riscv-tools-src/py/
echo "make install > build.log"

cd $ENV_PATH/rocket-soc/rocket_soc/rocket-lut/
"make install > build.log"

# Finished
echo "Finished: Environment is set up!"
