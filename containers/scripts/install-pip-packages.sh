#!/usr/bin/env bash
set -ex

echo 'Installing CUDA supported python packages'

export PIP_DEFAULT_TIMEOUT=100

pip3 install --user --no-cache-dir --verbose \
    torch \
    torchvision \
    numpy \
    scipy \
    scikit-learn \
    matplotlib \
    onnx \
    onnxruntime-gpu \
    ultralytics \
    cupy-cuda12x \
    flask

pip3 install --upgrade pycuda