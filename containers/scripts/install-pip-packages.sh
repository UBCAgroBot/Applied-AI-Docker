#!/usr/bin/env bash
set -ex

echo 'Installing CUDA supported python packages'

export PIP_DEFAULT_TIMEOUT=100

pip3 install --no-cache-dir --verbose \
    torch \
    torchvision \
    numpy \
    scipy \
    scikit-learn \
    matplotlib \
    onnx \
    onnxruntime-gpu \
    cupy-cuda12x \
    pycuda \
    ultralytics

apt update && apt upgrade -y
apt-get install -y --no-install-recommends sudo
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
