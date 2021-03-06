#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#

set -e

script_dir=$(cd "$(dirname "$0")" && pwd)
build_root=$(cd "${script_dir}/.." && pwd)
log_dir=$build_root
build_folder=$build_root"/build"

rm -r -f $build_folder
mkdir -p $build_folder
pushd $build_folder
cmake -DENABLE_UNIT_TESTS=ON -DENABLE_INT_TESTS=ON..
cmake --build . -- --jobs=$(nproc)

popd
