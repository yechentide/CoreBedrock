#!/usr/bin/env bash
set -eu

# for another architectures, check https://github.com/leetal/ios-cmake
declare -a -r platforms=('OS64' 'MAC_ARM64' 'SIMULATORARM64')

declare -r working_dir='/tmp/CoreBedrockLibsBuilder'
declare -r output="$working_dir/frameworks"

declare -r zlib_repo_path="$working_dir/zlib"
declare -r lvdb_repo_path="$working_dir/leveldb"
declare -r cmake_toolchain_path="$working_dir/ios.toolchain.cmake"

# ########## ########## ########## ########## ########## ########## ########## #

SCRIPT_ROOT_DIR=$(cd "$(dirname "$0")";pwd)
declare -r SCRIPT_ROOT_DIR

export PATH="$SCRIPT_ROOT_DIR/utils:$PATH"

# ########## ########## ########## ########## ########## ########## ########## #

function prepare() {
    if which cmake > /dev/null 2>&1; then
        logger 'ok' 'Command "cmake" found!'
    else
        logger 'error' 'Command "cmake" not found!'
        logger 'tip' 'You can install cmake by running "brew install --formula cmake".'
        exit 1
    fi

    if xcode-select -print-path | grep '^/Applications' > /dev/null 2>&1; then
        logger 'ok' "Xcode command line tools found in $(xcode-select -print-path)"
        xcodebuild -showsdks
    else
        logger 'error' 'Xcode command line tools not found!'
        logger 'tip' 'You need to install Xcode and update SDK path.'
        logger 'tip' '1. Install Xcode from App Store.'
        logger 'tip' '2. Run "sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer"'
        logger 'tip' ''
        logger 'tip' 'Example correct path: /Applications/Xcode.app/Contents/Developer'
        logger 'tip' 'The one installed by running "xcode-select --install"'
        logger 'tip' 'Example bad path: /Library/Developer/CommandLineTools (no iOS SDK here!)'
        exit 1
    fi

    if [[ -e $working_dir ]]; then
        logger 'warn' "Delete working directory in $working_dir"
        rm -rf $working_dir;
    fi
    mkdir -p $output
    logger 'ok' "Output directory created in $output"

    logger 'info' "Cloning the repository of madler/zlib ..."
    git clone --local https://github.com/madler/zlib.git "$zlib_repo_path"
    git -C "$zlib_repo_path" checkout 0f51fb4933fc9ce18199cb2554dacea8033e7fd3
    mkdir -p "$zlib_repo_path/include"
    cp "$zlib_repo_path"/*.h "$zlib_repo_path/include"

    logger 'info' "Cloning the repository of Amulet-Team/leveldb-mcpe ..."
    git clone https://github.com/Amulet-Team/leveldb-mcpe.git "$lvdb_repo_path"
    git -C "$lvdb_repo_path" checkout c446a37734d5480d4ddbc371595e7af5123c4925
    git -C "$lvdb_repo_path" apply "$SCRIPT_ROOT_DIR/lvdb.diff"

    logger 'info' "Cloning the repository of leetal/ios-cmake ..."
    git clone https://github.com/leetal/ios-cmake.git "$working_dir/ios-cmake"
    ln -s $working_dir/ios-cmake/ios.toolchain.cmake $cmake_toolchain_path
}

# $1: library
# $2: platform
function mv_built_lib() {
    declare -r dst_dir=$output/$1-$2
    if [[ -e $dst_dir ]]; then rm -rf "$dst_dir"; fi
    case $2 in
    'OS64')
        mv Release-iphoneos "$dst_dir"
        ;;
    'MAC' | 'MAC_ARM64' | 'MAC_UNIVERSAL')
        mv Release "$dst_dir"
        ;;
    'SIMULATOR64' | 'SIMULATORARM64')
        mv Release-iphonesimulator "$dst_dir"
        ;;
    *)
        logger 'error' "Unsupported platform $2"
        exit 1
        ;;
    esac
    logger 'ok' "Moved the built $1 library to $dst_dir."
}

function build_zlib() {
    rm -rf "$output/libz-*" > /dev/null 2>&1
    cd $zlib_repo_path
    declare -r zlib_build_dir="$zlib_repo_path/build"

    for platform in "${platforms[@]}"; do
        logger 'info' "Building libz for platform $platform ..."

        if [[ -e $zlib_build_dir ]]; then rm -rf $zlib_build_dir; fi
        mkdir -p $zlib_build_dir && cd $zlib_build_dir

        cmake .. -G Xcode -DPLATFORM="$platform" \
            -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_path \
            -DZLIB_BUILD_EXAMPLES=OFF
        cmake --build . --config Release -- CODE_SIGNING_ALLOWED=NO
        mv_built_lib 'libz' "$platform"
    done
}

function build_libleveldb() {
    rm -rf "$output/libleveldb-*" > /dev/null 2>&1
    cd $lvdb_repo_path
    declare -r libleveldb_build_dir="$lvdb_repo_path/build"

    for platform in "${platforms[@]}"; do
        logger 'info' "Building libleveldb for platform $platform ..."

        if [[ -e $libleveldb_build_dir ]]; then rm -rf $libleveldb_build_dir; fi
        mkdir -p $libleveldb_build_dir && cd $libleveldb_build_dir

        cmake .. -G Xcode -DPLATFORM="$platform" \
            -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_path \
            -DZLIB_INCLUDE_DIRS="$zlib_repo_path/include" \
            -DZLIB_LIBRARIES="$output/libz-$platform/libz.a"
        cmake --build . --config Release -- CODE_SIGNING_ALLOWED=NO
        mv_built_lib 'libleveldb' "$platform"
    done
}

function make_framework() {
    cd $output

    # Create fat libraries if needed
    # lipo -create libz-MAC/libz.a libz-MAC_ARM64/libz.a -output libz.a
    # lipo -create libleveldb-MAC/libleveldb.a libleveldb-MAC_ARM64/libleveldb.a -output libleveldb.a

    xcodebuild -create-xcframework \
        -library libz-OS64/libz.a \
        -headers "$zlib_repo_path/include" \
        -library libz-MAC_ARM64/libz.a \
        -headers "$zlib_repo_path/include" \
        -library libz-SIMULATORARM64/libz.a \
        -headers "$zlib_repo_path/include" \
        -output libz.xcframework
    
    xcodebuild -create-xcframework \
        -library libleveldb-OS64/libleveldb.a \
        -headers "$lvdb_repo_path/include" \
        -library libleveldb-MAC_ARM64/libleveldb.a \
        -headers "$lvdb_repo_path/include" \
        -library libleveldb-SIMULATORARM64/libleveldb.a \
        -headers "$lvdb_repo_path/include" \
        -output libleveldb.xcframework

    rm -rf "$SCRIPT_ROOT_DIR/../Dependencies/libz.xcframework" > /dev/null 2>&1
    rm -rf "$SCRIPT_ROOT_DIR/../Dependencies/libleveldb.xcframework" > /dev/null 2>&1

    declare -r dependencies_dir="$SCRIPT_ROOT_DIR/../Dependencies"
    if [[ ! -e "$dependencies_dir" ]]; then
        mkdir -p "$dependencies_dir"
    fi
    mv libz.xcframework "$dependencies_dir"
    mv libleveldb.xcframework "$dependencies_dir"
}

prepare
build_zlib
build_libleveldb
make_framework
