#!/usr/bin/env bash
set -ex

echo 'installing CUDA supported python packages'

export PIP_DEFAULT_TIMEOUT=100

python3 -m pip install --upgrade pip

apt-get install -y --no-install-recommends libboost-all-dev
echo 'export CPATH=$CPATH:/usr/local/cuda-12.2/targets/aarch64-linux/include' >> ~/.bashrc
echo 'export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-12.2/targets/aarch64-linux/lib' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/cuda-12.2/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.2/lib64' >> ~/.bashrc
# echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
# echo 'export PYTHONPATH=/usr/local/lib/python3.10/site-packages/:$PYTHONPATH' >> ~/.bashrc

pip3 install --trusted-host jetson.webredirect.org --verbose \
    torch --index-url http://jetson.webredirect.org/jp6/cu122 \
    torchvision --index-url http://jetson.webredirect.org/jp6/cu122 \
    numpy \
    scipy \
    scikit-learn \
    matplotlib \
    onnx \
    onnxruntime-gpu --index-url http://jetson.webredirect.org/jp6/cu122 \
    ultralytics \
    cupy --index-url http://jetson.webredirect.org/jp6/cu122 \
    pycuda --index-url http://jetson.webredirect.org/jp6/cu122 \
    argparse \
    flask \
    tqdm

# pip3 install --index-url http://jetson.webredirect.org/jp6/cu122 onnxruntime-gpu --trusted-host jetson.webredirect.org
# pip3 install --index-url http://jetson.webredirect.org/jp6/cu122 pycuda --trusted-host jetson.webredirect.org
# pip3 install --index-url http://jetson.webredirect.org/jp6/cu122 torch --trusted-host jetson.webredirect.org
# pip3 install --index-url http://jetson.webredirect.org/jp6/cu122 torchvision --trusted-host jetson.webredirect.org
# pip3 install --index-url http://jetson.webredirect.org/jp6/cu122 cupy --trusted-host jetson.webredirect.org

# pip3 install --no-cache-dir --verbose numpy scipy scikit-learn matplotlib 

# onnx ultralytics argparse tqdm flask

apt-get update && apt-get upgrade -y
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*