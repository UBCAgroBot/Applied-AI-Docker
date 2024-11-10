#!/usr/bin/env bash
set -ex

echo 'installing ZED SDK'

apt-get update -y || true ; apt-get install --no-install-recommends lsb-release wget less zstd udev  apt-transport-https -y
wget --no-check-certificate -O ZED_SDK_Linux.run https://download.stereolabs.com/zedsdk/4.1/cu121/ubuntu22
chmod +x ZED_SDK_Linux.run ; ./ZED_SDK_Linux.run silent skip_drivers
rm -rf /usr/local/zed/resources/* 
rm -rf ZED_SDK_Linux.run
rm -rf /var/lib/apt/lists/*
apt-get clean

echo 'installing pyzed'

apt-get update -y || true ; apt-get install --no-install-recommends python3 python3-pip python3-dev python3-setuptools build-essential -y
wget download.stereolabs.com/zedsdk/pyzed -O /usr/local/zed/get_python_api.py
python3 /usr/local/zed/get_python_api.py
python3 -m pip install cython wheel
python3 -m pip install numpy pyopengl *.whl
rm *.whl ; rm -rf /var/lib/apt/lists/* 
apt-get clean