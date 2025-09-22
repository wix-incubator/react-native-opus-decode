#!/usr/bin/env bash
set -euo pipefail

# -------- Settings --------
MIN_IOS="12.0"

# Where the Opus sources live (submodule or folder).
# You can override by exporting OPUS_DIR=/path/to/opus before calling the script.
ROOT_DIR="$(cd "$(dirname "$0")/.."; pwd)"
OPUS_DIR="${OPUS_DIR:-${ROOT_DIR}/third_party/opus}"

# Build/output folders
BUILD_ROOT="${ROOT_DIR}/build/opus"
OUT_DIR="${ROOT_DIR}/ios/opus"

# Xcode toolchain
export LIBTOOLIZE="${LIBTOOLIZE:-glibtoolize}"

# Clean and prep
rm -rf "${BUILD_ROOT}"
mkdir -p "${BUILD_ROOT}" "${OUT_DIR}"

# If building from a git checkout of opus, autogen.sh needs GNU libtool (glibtoolize)
if [[ ! -f "${OPUS_DIR}/configure" && -f "${OPUS_DIR}/autogen.sh" ]]; then
  (cd "${OPUS_DIR}" && ./autogen.sh)
fi

configure_build () {
  local SDK_NAME="$1"      # iphoneos | iphonesimulator
  local ARCH="$2"          # arm64 | x86_64
  local HOST="$3"          # aarch64-apple-darwin | x86_64-apple-darwin
  local MIN_FLAG="$4"      # -miphoneos-version-min=... OR -mios-simulator-version-min=...
  local BUILD_DIR="${BUILD_ROOT}/${SDK_NAME}-${ARCH}"

  local SDK_PATH CC_BIN
  SDK_PATH="$(xcrun --sdk "${SDK_NAME}" --show-sdk-path)"
  CC_BIN="$(xcrun --sdk "${SDK_NAME}" -f clang)"

  rm -rf "${BUILD_DIR}"
  mkdir -p "${BUILD_DIR}"
  pushd "${BUILD_DIR}" >/dev/null

  "${OPUS_DIR}/configure" \
    --host="${HOST}" \
    --disable-shared --enable-static \
    --with-pic \
    CC="${CC_BIN}" \
    CFLAGS="-isysroot ${SDK_PATH} -arch ${ARCH} -O3 -fvisibility=hidden ${MIN_FLAG}" \
    LDFLAGS="-isysroot ${SDK_PATH} -arch ${ARCH}"

  make -j"$(sysctl -n hw.ncpu)"
  popd >/dev/null
}

echo "🔧 Building Opus"
# 1) Device arm64
configure_build iphoneos       arm64 aarch64-apple-darwin "-miphoneos-version-min=${MIN_IOS}"

# 2) Simulator arm64
configure_build iphonesimulator arm64 aarch64-apple-darwin "-mios-simulator-version-min=${MIN_IOS}"

# 3) Simulator x86_64  (ALWAYS build; keeps CI & Intel devs happy)
configure_build iphonesimulator x86_64 x86_64-apple-darwin "-mios-simulator-version-min=${MIN_IOS}"

# Paths to the built static libs
DEV_LIB="${BUILD_ROOT}/iphoneos-arm64/.libs/libopus.a"
SIM_ARM64_LIB="${BUILD_ROOT}/iphonesimulator-arm64/.libs/libopus.a"
SIM_X64_LIB="${BUILD_ROOT}/iphonesimulator-x86_64/.libs/libopus.a"

# 4) Create a FAT simulator lib (arm64 + x86_64)
SIM_FAT="${BUILD_ROOT}/iphonesimulator-fat/libopus.a"
rm -f "${SIM_FAT}"
mkdir -p "$(dirname "${SIM_FAT}")"
lipo -create "${SIM_ARM64_LIB}" "${SIM_X64_LIB}" -output "${SIM_FAT}"

# 5) Package as an XCFramework
rm -rf "${OUT_DIR}/Opus.xcframework"
xcodebuild -create-xcframework \
  -library "${DEV_LIB}" -headers "${OPUS_DIR}/include" \
  -library "${SIM_FAT}" -headers "${OPUS_DIR}/include" \
  -output "${OUT_DIR}/Opus.xcframework"

echo "=== XCFramework slices ==="
find "${OUT_DIR}/Opus.xcframework" -name "*.a" -maxdepth 3 -print -exec file {} \;

echo "✅ Built ${OUT_DIR}/Opus.xcframework"