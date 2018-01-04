#!/usr/bin/env bash
set -x -e

cd ../..
git submodule update --init --recursive
cd fonts
./install.sh
