#!/usr/bin/env bash
set -ex

echo 'Installing CUDA supported python packages'

export PIP_DEFAULT_TIMEOUT=100

python3 -m pip install --upgrade pip

pip3 install --no-cache-dir --verbose --ignore-installed blinker

pip3 install --no-cache-dir --verbose \
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
    pycuda \
    flask \
    tqdm