#!/bin/bash
#
# Script to build PACO enviroment
#

ENV_PATH=`pwd`
JOBS=4

# Color helpers
RED='\033[0;31m'
CYAN='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
ERROR="${RED}Error:${NC}"

# Check for superuser
if [ $(id -u) = "0" ]; then
    printf "${ERROR} Don't run this script as root!\n"
fi
      
# Setup the environment
if [ "x$RISCV" = "x" ]
then 
    printf "${ERROR} RISCV variable not found. Getting it from $ENV_PATH/env.sh\n"
    . $ENV_PATH/env.sh
fi 
#############################
#
# Build RISCV toolchain first
#
#############################

printf "${CYAN}Building RISCV toolchain ...${NC}\n"
# create this dir such that the riscv-tests can be installed.
mkdir -p $(RISCV)/riscv64-unknown-elf/share/riscv-tests
cd $ENV_PATH/riscv-tools-src/
. build.sh

#############################
#
#       Build LLVM
#
#############################
printf "${CYAN}Building LLVM ...${NC}\n"
mkdir -p $ENV_PATH/riscv-tools-src/riscv-llvm/build
cd $ENV_PATH/riscv-tools-src/riscv-llvm/build
# check if libuuid is installed
pkg-config --exists uuid
uuid_exits=`echo $?`
if [ $uuid_exits -eq 1 ] 
then
    printf "${ERROR} libuuid is not installed..\n"
    exit 1
fi 

# don't configure twice
if [ -f config.log ]
then
    read -p "LLVM was already configured. Configure again?[Y/n]" yn
    case $yn in
        [Yy]* ) CC=gcc CXX=g++ ../configure --enable-targets=riscv --prefix=$RISCV > build.log; break;;
        [Nn]* ) ;;
        * ) printf "${Error}Please answer yes or no.${NC}\n";;
    esac
else 
    CC=gcc CXX=g++ ../configure --enable-targets=riscv --prefix=$RISCV > build.log
fi 

make -j$JOBS LDFLAGS=-luuid >> build.log
make install >> build.log

# Build LUT-compiler
printf "${CYAN}Building LUT-compiler ...${NC}\n"
cd $ENV_PATH/riscv-tools-src/riscv-lut-compiler
make clean > /dev/null
make -j$JOBS > build.log && make install >> build.log

# Installing python libs
printf "${CYAN}Installing python libs ...${NC}\n"
cd $ENV_PATH/riscv-tools-src/py/
make install > build.log

cd $ENV_PATH/rocket-soc/rocket_soc/rocket-lut/
make install > build.log

# Install rocket-lib
printf "${CYAN}Installing rocket-lib ...${NC}\n"
cd $ENV_PATH/rocket-soc/rocket_soc/lib
make > build.sh && make install >> build.log

# Finished
printf "${GREEN}Finished: Environment is set up!\n"
