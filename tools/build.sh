#!/bin/bash

set -e

HARWARE_CONCURRENCY=$(nproc)
readonly HARWARE_CONCURRENCY

linker=DEFAULT
generator="Unix Makefiles"
build_type=Debug
build_dir=build
cxx_compiler=g++-14
c_compiler=gcc-14
extra_args=()

if command -v mold >&2; then
  linker=MOLD
fi

if command -v ninja >&2; then
  generator=Ninja
fi

echo Configuration
echo ----------------------------
echo -- Build Type:    "$build_type"
echo -- Linker:        "$linker"
echo -- Generator:     "$generator"
echo -- Build Dir:     "$build_dir"
echo -- CXX Compiler:  "$cxx_compiler"
echo -- C Compiler:    "$c_compiler"
echo -- Extra Args:
for arg in "${extra_args[@]}"; do
	echo -- -- "${arg}"
done
echo ----------------------------
cmake -B$build_dir -DCMAKE_CXX_COMPILER=$cxx_compiler -DCMAKE_C_COMPILER=$c_compiler -DCMAKE_BUILD_TYPE=$build_type -DCMAKE_LINKER_TYPE=${linker} -G "$generator" "${extra_args[@]}" -H.
cmake --build build -j"${HARWARE_CONCURRENCY}"
result=$?
echo Done
exit $result