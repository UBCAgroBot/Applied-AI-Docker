#!/usr/bin/env bash
set -ex

echo 'installing gstreamer'

apt update && apt install -y libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-good1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-libav \
    gstreamer1.0-tools