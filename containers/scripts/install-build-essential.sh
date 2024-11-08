#!/usr/bin/env bash
set -ex

echo 'installing build-essential'

apt -y update && apt -y upgrade
apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    lsb-release \
    pkg-config \
    gnupg \
    git \
    gdb \
    wget \
    curl \
    nano \
    zip \
    unzip \
    time \
    sshpass \
    ssh-client \
    plocate \
    libboost-all-dev \
    xz-utils \
    libnss3-tools \
    libx11-dev \
    xauth \
    apt-utils \
    dialog

apt-get clean 
rm -rf /var/lib/apt/lists/* 
gcc --version 
g++ --version