#!/bin/bash
#
# Build knor inside the strahler-knor docker image with -march=native so the
# resulting binary takes advantage of the host's vector instructions
# (especially relevant for --strpm-simd). Run this once after starting the
# container; subsequent runs are skipped if the binary already exists.
#
# Snapshot the container after running this if you want to keep the compiled
# binary for later sessions:
#     docker commit <container_id> ghcr.io/<you>/strahler-knors:compiled

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
NPROC="$(nproc)"

if [ -x "$BUILD/knor" ]; then
    echo "knor already built at $BUILD/knor (remove $BUILD to rebuild)."
    exit 0
fi

mkdir -p "$BUILD"
cd "$BUILD"

# -march=native is added on top of the project's RelWithDebInfo flags via
# CMAKE_C_FLAGS_INIT / CMAKE_CXX_FLAGS_INIT so the Boolean operators in sylvan
# and the SIMD codepaths in oink's strpm_simd compile against the host's
# instruction set.
CFLAGS="-march=native -O3" \
CXXFLAGS="-march=native -O3" \
cmake -DCMAKE_BUILD_TYPE=Release "$ROOT"

make -j"$NPROC" knor

echo
echo "knor built at $BUILD/knor."
echo "Run scripts/knor-strpm-simd.sh to invoke it with --strpm-simd."
