#!/bin/bash

set -e

NVIM_INSTALL_PREFIX="${NVIM_INSTALL_PREFIX:-$HOME/.local}"

rm $NVIM_INSTALL_PREFIX/bin/nvim

rm -rf $NVIM_INSTALL_PREFIX/lib/nvim

rm -rf $NVIM_INSTALL_PREFIX/share/nvim
rm $NVIM_INSTALL_PREFIX/share/applications/nvim.desktop
rm $NVIM_INSTALL_PREFIX/share/icons/hicolor/128x128/apps/nvim.png
rm $NVIM_INSTALL_PREFIX/share/man/man1/nvim.1
