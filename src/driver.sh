#!/usr/bin/env bash

set -exu -o pipefail

function genTablesForCPU() {
    local target_triple="$1"
    local sysroot="$2"
    local compiler="$3"
    local qemu="$4"

    CFLAGS="-I. -I.. -I../JudyCommon -static"

    pushd Judy1
    ln -sf ../JudyCommon/JudyTables.c Judy1TablesGen.c
    $compiler $CFLAGS -DJUDY1 ./Judy1TablesGen.c -o ./Judy1TablesGen
    $qemu -L $sysroot ./Judy1TablesGen
    $compiler $CFLAGS -c -DJUDY1 Judy1Tables.c
    mv Judy1Tables.c /tmp/$target_triple-judy1-tables.c
    popd

    pushd JudyL
    ln -sf ../JudyCommon/JudyTables.c JudyLTablesGen.c
    $compiler $CFLAGS -DJUDYL ./JudyLTablesGen.c -o ./JudyLTablesGen
    $qemu -L $sysroot ./JudyLTablesGen
    $compiler $CFLAGS -c -DJUDYL JudyLTables.c
    mv JudyLTables.c /tmp/$target_triple-judyl-tables.c
    popd
}

TOOLCHAINS_DIR="${TOOLCHAINS_DIR:-$HOME/x-tools}"

TARGET_TRIPLE="aarch64-unknown-linux-gnu"
SYSROOT_DIR="$TOOLCHAINS_DIR/$TARGET_TRIPLE/$TARGET_TRIPLE/sysroot"
COMPILER="$TOOLCHAINS_DIR/$TARGET_TRIPLE/bin/$TARGET_TRIPLE-gcc"
QEMU="qemu-aarch64-static"
genTablesForCPU $TARGET_TRIPLE $SYSROOT_DIR $COMPILER $QEMU

TARGET_TRIPLE="arm-unknown-linux-gnueabi"
SYSROOT_DIR="$TOOLCHAINS_DIR/$TARGET_TRIPLE/$TARGET_TRIPLE/sysroot"
COMPILER="$TOOLCHAINS_DIR/$TARGET_TRIPLE/bin/$TARGET_TRIPLE-gcc"
QEMU="qemu-arm-static"
genTablesForCPU $TARGET_TRIPLE $SYSROOT_DIR $COMPILER $QEMU

TARGET_TRIPLE="mipsel-unknown-linux-gnu"
SYSROOT_DIR="$TOOLCHAINS_DIR/$TARGET_TRIPLE/$TARGET_TRIPLE/sysroot"
COMPILER="$TOOLCHAINS_DIR/$TARGET_TRIPLE/bin/$TARGET_TRIPLE-gcc"
QEMU="qemu-mipsel-static"
genTablesForCPU $TARGET_TRIPLE $SYSROOT_DIR $COMPILER $QEMU

TARGET_TRIPLE="mips-unknown-linux-gnu"
SYSROOT_DIR="$TOOLCHAINS_DIR/$TARGET_TRIPLE/$TARGET_TRIPLE/sysroot"
COMPILER="$TOOLCHAINS_DIR/$TARGET_TRIPLE/bin/$TARGET_TRIPLE-gcc"
QEMU="qemu-mips-static"
genTablesForCPU $TARGET_TRIPLE $SYSROOT_DIR $COMPILER $QEMU

TARGET_TRIPLE="powerpc64-unknown-linux-gnu"
SYSROOT_DIR="$TOOLCHAINS_DIR/$TARGET_TRIPLE/$TARGET_TRIPLE/sysroot"
COMPILER="$TOOLCHAINS_DIR/$TARGET_TRIPLE/bin/$TARGET_TRIPLE-gcc"
QEMU="qemu-ppc64-static"
genTablesForCPU $TARGET_TRIPLE $SYSROOT_DIR $COMPILER $QEMU

TARGET_TRIPLE="x86_64-unknown-linux-gnu"
SYSROOT_DIR="$TOOLCHAINS_DIR/$TARGET_TRIPLE/$TARGET_TRIPLE/sysroot"
COMPILER="$TOOLCHAINS_DIR/$TARGET_TRIPLE/bin/$TARGET_TRIPLE-gcc"
QEMU="qemu-x86_64-static"
genTablesForCPU $TARGET_TRIPLE $SYSROOT_DIR $COMPILER $QEMU
