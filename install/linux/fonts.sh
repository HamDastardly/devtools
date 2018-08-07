#!/usr/bin/env bash
set -x -e

git clone https://github.com/powerline/fonts.git fonts
cd fonts
./install.sh
cd ..
rm -rf fonts
