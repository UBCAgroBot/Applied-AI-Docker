#!/usr/bin/env bash
set -ex

# CUDA toolkit must be installed on the system

echo 'Installing ffmpeg with CUDA support'

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

cd nv-codec-headers && make install && cd -

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

apt-get install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev

./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared

make -j 8

make install