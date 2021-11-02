#!/usr/bin/env bash

set -exu -o pipefail

./bootstrap
./configure --prefix=/home/vk/opt/judy
bear make V=1 -j 8
