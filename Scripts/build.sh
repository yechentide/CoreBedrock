#!/usr/bin/env bash
set -eu

# For other architectures, check https://github.com/leetal/ios-cmake
declare -a -r platforms=('OS64' 'MAC_UNIVERSAL' 'SIMULATORARM64')

declare -r working_dir='/tmp/CoreBedrockLibsBuilder'
declare -r output_dir="$working_dir/frameworks"

declare -r leveldb_repo_path="$working_dir/leveldb"
declare -r cmake_toolchain_repo_path="$working_dir/ios-cmake"
declare -r cmake_toolchain_file="$cmake_toolchain_repo_path/ios.toolchain.cmake"

declare -r CMAKE_PATH=''
if [[ ! -z $CMAKE_PATH ]]; then
    export PATH="$CMAKE_PATH:$PATH"
fi
declare -r NINJA_PATH=''
if [[ ! -z $NINJA_PATH ]]; then
    export PATH="$NINJA_PATH:$PATH"
fi

# ########## ########## ########## ########## ########## ########## ########## #
# Load utility functions

SCRIPT_ROOT_DIR=$(cd "$(dirname "$0")";pwd)
declare -r SCRIPT_ROOT_DIR

export PATH="$SCRIPT_ROOT_DIR/utils:$PATH"

# ########## ########## ########## ########## ########## ########## ########## #

function check_environment() {
    if [[ ! $(uname) == 'Darwin' ]]; then
        logger error 'This script is for macOS only';
        exit 1;
    fi
    if command -v git > /dev/null 2>&1; then
        logger 'ok' "Using $(git --version | head -n 1)"
    else
        logger 'error' 'Command "git" not found!'
        exit 1
    fi
    if command -v cmake > /dev/null 2>&1; then
        logger 'ok' "Using $(cmake --version | head -n 1)"
    else
        logger 'error' 'Command "cmake" not found!'
        logger 'tip' 'You can install cmake from https://github.com/Kitware/CMake/releases.'
        exit 1
    fi
    if command -v ninja > /dev/null 2>&1; then
        logger 'ok' "Using ninja version $(ninja --version | head -n 1)"
    else
        logger 'error' 'Command "cmake" not found!'
        logger 'tip' 'You can install cmake by running "brew install --formula cmake".'
        exit 1
    fi
    if xcode-select -print-path | grep '^/Applications' > /dev/null 2>&1; then
        logger 'ok' "Xcode command line tools found in $(xcode-select -print-path)"
        logger 'ok' "Using $(xcodebuild -version | tr '\n' ' ')"
    else
        logger 'error' 'Xcode command line tools not found!'
        logger 'tip' 'You need to install Xcode and update the SDK path.'
        logger 'tip' '1. Install Xcode from the App Store.'
        logger 'tip' '2. Run "sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer"'
        logger 'tip' ''
        logger 'tip' 'Correct path example: /Applications/Xcode.app/Contents/Developer'
        logger 'tip' 'Bad path example: /Library/Developer/CommandLineTools (no iOS SDK here!)'
        exit 1
    fi
    logger 'tip' 'Previously confirmed working versions: cmake 3.31.8, ninja 1.13.1'
    count_down -n 6 && echo ''
}

function prepare_sources() {
    if [[ -e $working_dir ]]; then
        logger 'warn' "Deleting working directory at $working_dir"
        rm -rf $working_dir;
    fi
    mkdir -p $working_dir
    logger 'ok' "Working directory created at $working_dir"
    count_down -n 6 && echo ''

    logger 'info' "Cloning repository Amulet-Team/leveldb ..."
    git clone https://github.com/Amulet-Team/leveldb.git "$leveldb_repo_path"
    git -C "$leveldb_repo_path" submodule update --init

    logger 'info' "Cloning repository leetal/ios-cmake ..."
    git clone https://github.com/leetal/ios-cmake.git "$cmake_toolchain_repo_path"
}

function build_static_libs() {
    for platform in "${platforms[@]}"; do
        logger 'info' '########## ########## ########## ########## ########## ##########'
        logger 'info' "Building static libraries for platform $platform ..."
        logger 'info' '########## ########## ########## ########## ########## ##########'
        count_down -n 3 && echo ''

        local build_dir="$leveldb_repo_path/build-$platform"
        if [[ -e "$build_dir" ]]; then rm -rf "$build_dir"; fi
        mkdir -p "$build_dir" && cd "$build_dir"

        cmake .. \
            -DCMAKE_BUILD_TYPE=Release \
            -G Ninja \
            -DPLATFORM="$platform" \
            -DCMAKE_TOOLCHAIN_FILE="$cmake_toolchain_file" \
            -DLEVELDB_INSTALL=OFF \
            -DLEVELDB_BUILD_TESTS=OFF \
            -DLEVELDB_BUILD_BENCHMARKS=OFF \
            -DLEVELDB_BUILD_UTILS=OFF

        cmake --build . --config Release
    done
    logger 'ok' "Static libraries successfully built!"
}

function build_xcframeworks() {
    rm -rf "$output_dir" > /dev/null 2>&1
    mkdir -p "$output_dir" && cd $output_dir

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libcrc32c.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        args+=(
            -library "$leveldb_repo_path/build-$p/_deps/crc32c-build/libcrc32c.a"
            -headers "$leveldb_repo_path/build-$p/_deps/crc32c-src/include"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libcrc32c.xcframework'

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libsnappy.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        local include_dir="$leveldb_repo_path/build-$p/_deps/snappy-include"
        rm -rf "$include_dir" && mkdir -p "$include_dir"
        cp "$leveldb_repo_path/build-$p/_deps/snappy-src/snappy.h" "$include_dir"
        args+=(
            -library "$leveldb_repo_path/build-$p/_deps/snappy-build/libsnappy.a"
            -headers "$include_dir"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libsnappy.xcframework'

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libz.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        local include_dir="$leveldb_repo_path/build-$p/_deps/zlib-include"
        rm -rf "$include_dir" && mkdir -p "$include_dir"
        cp "$leveldb_repo_path/build-$p/_deps/zlib-src/zlib.h" "$include_dir"
        args+=(
            -library "$leveldb_repo_path/build-$p/_deps/zlib-build/libz.a"
            -headers "$include_dir"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libz.xcframework'

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libzstd.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        local include_dir="$leveldb_repo_path/build-$p/_deps/zstd-include"
        rm -rf "$include_dir" && mkdir -p "$include_dir"
        cp "$leveldb_repo_path/build-$p/_deps/zstd-src/lib/zstd.h" "$include_dir"
        args+=(
            -library "$leveldb_repo_path/build-$p/_deps/zstd-build/lib/libzstd.a"
            -headers "$include_dir"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libzstd.xcframework'

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libleveldb.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        args+=(
            -library "$leveldb_repo_path/build-$p/libleveldb.a"
            -headers "$leveldb_repo_path/include"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libleveldb.xcframework'
    
    echo ''
    logger 'ok' "XCFrameworks successfully generated at $output_dir"
    count_down -n 3 && echo ''
    open "$output_dir"
}

check_environment
prepare_sources
build_static_libs
build_xcframeworks
