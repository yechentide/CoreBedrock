#!/usr/bin/env bash
set -eu

# For other architectures, check https://github.com/leetal/ios-cmake
declare -a -r platforms=('OS64' 'MAC_UNIVERSAL' 'SIMULATORARM64')
declare -a -r libjpeg_turbo_platforms=('OS64' 'MAC_ARM64' 'MAC' 'SIMULATORARM64')

declare -r working_dir='/tmp/CoreBedrockLibsBuilder'
declare -r output_dir="$working_dir/frameworks"

declare -r leveldb_repo_path="$working_dir/leveldb"
declare -r libjpeg_turbo_repo_path="$working_dir/libjpeg-turbo"
declare -r libpng_repo_path="$working_dir/libpng"
declare -r cmake_toolchain_repo_path="$working_dir/ios-cmake"
declare -r cmake_toolchain_file="$cmake_toolchain_repo_path/ios.toolchain.cmake"
declare -r leveldb_commit='1352243bb27d287b27be94f7591218dddb3ef900'
declare -r libjpeg_turbo_commit='9217719d3a58633923b096af4c1d50d304768a64'
declare -r libpng_commit='3061454d980de7d53608f594194cfac722721d2a'
declare -r cmake_toolchain_commit='21598aa550701d20654c032328f7e8710a14099b'
declare -r libjpeg_turbo_arm64_neon="${LIBJPEG_TURBO_ARM64_NEON:-ON}"
declare -r build_libjpeg_compat_xcframework="${BUILD_LIBJPEG_COMPAT_XCFRAMEWORK:-OFF}"

export ZERO_AR_DATE=1

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

SCRIPT_ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
declare -r SCRIPT_ROOT_DIR
LIBRARIES_DIR=$(cd "$SCRIPT_ROOT_DIR/.." && pwd)/Libraries
declare -r LIBRARIES_DIR

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
        logger 'error' 'Command "ninja" not found!'
        logger 'tip' 'You can install ninja by running "brew install --formula ninja".'
        exit 1
    fi
    if command -v lipo > /dev/null 2>&1; then
        logger 'ok' 'Using lipo'
    else
        logger 'error' 'Command "lipo" not found!'
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

function clone_repository() {
    local name="$1"
    local url="$2"
    local commit="$3"
    local path="$4"

    logger 'info' "Cloning repository $name ($commit) ..."
    git clone "$url" "$path"
    git -C "$path" checkout --detach "$commit"
}

function prepare_sources() {
    if [[ -e $working_dir ]]; then
        logger 'warn' "Deleting working directory at $working_dir"
        rm -rf $working_dir;
    fi
    mkdir -p $working_dir
    logger 'ok' "Working directory created at $working_dir"
    count_down -n 6 && echo ''

    clone_repository \
        'Amulet-Team/leveldb' \
        'https://github.com/Amulet-Team/leveldb.git' \
        "$leveldb_commit" \
        "$leveldb_repo_path"
    git -C "$leveldb_repo_path" submodule update --init

    clone_repository \
        'libjpeg-turbo/libjpeg-turbo' \
        'https://github.com/libjpeg-turbo/libjpeg-turbo.git' \
        "$libjpeg_turbo_commit" \
        "$libjpeg_turbo_repo_path"

    clone_repository \
        'pnggroup/libpng' \
        'https://github.com/pnggroup/libpng.git' \
        "$libpng_commit" \
        "$libpng_repo_path"

    clone_repository \
        'leetal/ios-cmake' \
        'https://github.com/leetal/ios-cmake.git' \
        "$cmake_toolchain_commit" \
        "$cmake_toolchain_repo_path"
}

function libjpeg_turbo_simd_for_platform() {
    local platform="$1"

    case "$platform" in
        OS64|SIMULATORARM64|MAC_ARM64)
            echo "$libjpeg_turbo_arm64_neon"
            ;;
        *)
            echo 'OFF'
            ;;
    esac
}

function normalize_xcframework_info_plist() {
    local plist="$1"
    local count
    count=$(plutil -extract AvailableLibraries raw -expect array "$plist")

    if [[ "$count" -le 1 ]]; then
        return 0
    fi

    /usr/libexec/PlistBuddy -c 'Delete :_SortedAvailableLibraries' "$plist" >/dev/null 2>&1 || true
    /usr/libexec/PlistBuddy -c 'Add :_SortedAvailableLibraries array' "$plist"

    local out_index=0
    local identifier
    while read -r source_index; do
        /usr/libexec/PlistBuddy \
            -c "Copy :AvailableLibraries:$source_index :_SortedAvailableLibraries:$out_index" \
            "$plist"
        out_index=$((out_index + 1))
    done < <(
        for ((i = 0; i < count; i++)); do
            identifier=$(plutil -extract "AvailableLibraries.$i.LibraryIdentifier" raw -expect string "$plist")
            printf '%s\t%s\n' "$identifier" "$i"
        done | LC_ALL=C sort -k1,1 -k2,2n | cut -f2
    )

    /usr/libexec/PlistBuddy -c 'Delete :AvailableLibraries' "$plist"
    /usr/libexec/PlistBuddy -c 'Copy :_SortedAvailableLibraries :AvailableLibraries' "$plist"
    /usr/libexec/PlistBuddy -c 'Delete :_SortedAvailableLibraries' "$plist"
    plutil -convert xml1 "$plist"
}

function build_static_libs() {
    for platform in "${platforms[@]}"; do
        logger 'info' '########## ########## ########## ########## ########## ##########'
        logger 'info' "Building LevelDB and libpng static libraries for platform $platform ..."
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

        build_dir="$libpng_repo_path/build-$platform"
        local install_dir="$build_dir/install"
        local zlib_include_dir="$leveldb_repo_path/build-$platform/_deps/zlib-png-include"
        local zlib_library="$leveldb_repo_path/build-$platform/_deps/zlib-build/libz.a"
        if [[ -e "$build_dir" ]]; then rm -rf "$build_dir"; fi
        rm -rf "$zlib_include_dir" && mkdir -p "$zlib_include_dir"
        cp "$leveldb_repo_path/build-$platform/_deps/zlib-src/zlib.h" "$zlib_include_dir"
        cp "$leveldb_repo_path/build-$platform/_deps/zlib-build/zconf.h" "$zlib_include_dir"
        mkdir -p "$build_dir" && cd "$build_dir"

        cmake "$libpng_repo_path" \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX="$install_dir" \
            -G Ninja \
            -DPLATFORM="$platform" \
            -DCMAKE_TOOLCHAIN_FILE="$cmake_toolchain_file" \
            -DPNG_SHARED=OFF \
            -DPNG_STATIC=ON \
            -DPNG_TESTS=OFF \
            -DPNG_TOOLS=OFF \
            -DPNG_EXECUTABLES=OFF \
            -DPNG_FRAMEWORK=OFF \
            -DPNG_HARDWARE_OPTIMIZATIONS=ON \
            -DZLIB_INCLUDE_DIR="$zlib_include_dir" \
            -DZLIB_LIBRARY="$zlib_library"

        cmake --build . --config Release
        cmake --install . --config Release
    done

    for platform in "${libjpeg_turbo_platforms[@]}"; do
        logger 'info' '########## ########## ########## ########## ########## ##########'
        logger 'info' "Building libjpeg-turbo static libraries for platform $platform ..."
        logger 'info' '########## ########## ########## ########## ########## ##########'
        count_down -n 3 && echo ''

        local build_dir="$libjpeg_turbo_repo_path/build-$platform"
        local install_dir="$build_dir/install"
        local libjpeg_turbo_with_simd
        libjpeg_turbo_with_simd=$(libjpeg_turbo_simd_for_platform "$platform")
        if [[ -e "$build_dir" ]]; then rm -rf "$build_dir"; fi
        mkdir -p "$build_dir" && cd "$build_dir"

        cmake "$libjpeg_turbo_repo_path" \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX="$install_dir" \
            -G Ninja \
            -DPLATFORM="$platform" \
            -DCMAKE_TOOLCHAIN_FILE="$cmake_toolchain_file" \
            -DENABLE_SHARED=OFF \
            -DENABLE_STATIC=ON \
            -DWITH_JAVA=OFF \
            -DWITH_TOOLS=OFF \
            -DWITH_TESTS=OFF \
            -DWITH_FUZZ=OFF \
            -DWITH_SIMD="$libjpeg_turbo_with_simd"

        cmake --build . --config Release
        cmake --install . --config Release
    done

    local universal_dir="$libjpeg_turbo_repo_path/build-MAC_UNIVERSAL/install"
    rm -rf "$universal_dir"
    mkdir -p "$universal_dir/lib"
    cp -R "$libjpeg_turbo_repo_path/build-MAC_ARM64/install/include" "$universal_dir/include"
    lipo -create \
        "$libjpeg_turbo_repo_path/build-MAC_ARM64/install/lib/libjpeg.a" \
        "$libjpeg_turbo_repo_path/build-MAC/install/lib/libjpeg.a" \
        -output "$universal_dir/lib/libjpeg.a"
    lipo -create \
        "$libjpeg_turbo_repo_path/build-MAC_ARM64/install/lib/libturbojpeg.a" \
        "$libjpeg_turbo_repo_path/build-MAC/install/lib/libturbojpeg.a" \
        -output "$universal_dir/lib/libturbojpeg.a"

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
        cp "$leveldb_repo_path/build-$p/_deps/zlib-build/zconf.h" "$include_dir"
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

    if [[ "$build_libjpeg_compat_xcframework" == 'ON' ]]; then
        logger 'info' '########## ########## ########## ########## ########## ##########'
        logger 'info' 'Creating libjpeg.xcframework ...'
        local args=()
        for p in "${platforms[@]}"; do
            args+=(
                -library "$libjpeg_turbo_repo_path/build-$p/install/lib/libjpeg.a"
                -headers "$libjpeg_turbo_repo_path/build-$p/install/include"
            )
        done
        xcodebuild -create-xcframework \
            "${args[@]}" \
            -output 'libjpeg.xcframework'
    fi

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libturbojpeg.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        args+=(
            -library "$libjpeg_turbo_repo_path/build-$p/install/lib/libturbojpeg.a"
            -headers "$libjpeg_turbo_repo_path/build-$p/install/include"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libturbojpeg.xcframework'

    logger 'info' '########## ########## ########## ########## ########## ##########'
    logger 'info' 'Creating libpng.xcframework ...'
    local args=()
    for p in "${platforms[@]}"; do
        args+=(
            -library "$libpng_repo_path/build-$p/install/lib/libpng16.a"
            -headers "$libpng_repo_path/build-$p/install/include/libpng16"
        )
    done
    xcodebuild -create-xcframework \
        "${args[@]}" \
        -output 'libpng.xcframework'

    logger 'info' 'Normalizing XCFramework Info.plist files ...'

    local plist
    for plist in "$output_dir"/*.xcframework/Info.plist; do
        normalize_xcframework_info_plist "$plist"
    done

    echo ''
    logger 'ok' "XCFrameworks successfully generated at $output_dir"
    count_down -n 3 && echo ''
    open "$output_dir"
}

function install_xcframeworks() {
    logger 'info' "Copying generated XCFrameworks to $LIBRARIES_DIR ..."
    mkdir -p "$LIBRARIES_DIR"

    for framework_path in "$output_dir"/*.xcframework; do
        local framework_name
        framework_name=$(basename "$framework_path")
        rm -rf "${LIBRARIES_DIR:?}/$framework_name"
        cp -R "$framework_path" "${LIBRARIES_DIR:?}/$framework_name"
    done

    if [[ "$build_libjpeg_compat_xcframework" != 'ON' ]]; then
        rm -rf "$LIBRARIES_DIR/libjpeg.xcframework"
    fi

    logger 'ok' "XCFrameworks copied to $LIBRARIES_DIR"
}

check_environment
prepare_sources
build_static_libs
build_xcframeworks
install_xcframeworks
