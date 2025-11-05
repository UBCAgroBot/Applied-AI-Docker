FROM nvcr.io/nvidia/pytorch:24.09-py3

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    build-essential \
    git \
    curl \
    ca-certificates \
    libjpeg-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk2.0-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-dev \
    libnvinfer-dev \
    libnvonnxparsers-dev \
    libboost-all-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'export CUDA_PATH=/usr/local/cuda-12.6/targets/x86_64-linux/include' >> ~/.bashrc \
    echo 'export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-12.6/targets/x86_64-linux/lib' >> ~/.bashrc \
    echo 'export PATH=$PATH:/usr/local/cuda-12.6/bin' >> ~/.bashrc \
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64/stubs' >> ~/.bashrc

RUN apt-get update && apt install -y --no-install-recommends \
    libopencv-dev

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/hpcx/ucx/lib
ENV CPATH=$CPATH:/usr/local/cuda-12.6/targets/x86_64-linux/include
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-12.6/targets/x86_64-linux/lib
ENV PATH=$PATH:/usr/local/cuda-12.6/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.6/lib64
ENV PATH=/home/vscode/.local/bin:$PATH

ENTRYPOINT [ "/bin/bash" ]