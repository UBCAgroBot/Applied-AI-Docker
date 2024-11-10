#!/usr/bin/env bash
set -ex

echo 'installing ZED SDK'

apt-get update -y && apt-get install -y --no-install-recommends \
    lsb-release \
    wget \
    less \
    zstd \
    udev \
    apt-transport-https

wget --no-check-certificate -O ZED_SDK_Linux.run https://download.stereolabs.com/zedsdk/4.2/cu12/ubuntu22
chmod +x ZED_SDK_Linux.run
./ZED_SDK_Linux.run -- silent skip_cuda skip_od_module
rm -rf /usr/local/zed/resources/* 
rm -rf ZED_SDK_Linux.run
apt-get clean 
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*