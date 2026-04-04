#!/bin/bash

set -ex

NVIM_INSTALL_PREFIX="${NVIM_INSTALL_PREFIX:-$HOME/.local}"
NVIM_GIT_REF="${NVIM_GIT_REF:-stable}"

cur_dir="$(pwd)"
tmp_dir="$(mktemp -d)"
archive_url="https://github.com/neovim/neovim/archive/${NVIM_GIT_REF}.tar.gz"

cd "${tmp_dir}"

mkdir neovim
curl -o neovim.tar.gz -fsSL "$archive_url"
tar zxf neovim.tar.gz

cd "neovim-${NVIM_GIT_REF}"

make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="${NVIM_INSTALL_PREFIX}"
make install

cd "${cur_dir}"
rm -rf "${tmp_dir}"
