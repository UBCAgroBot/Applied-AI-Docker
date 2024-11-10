FROM nvcr.io/nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04 AS base
ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts
RUN apt-get update && apt-get install -y dos2unix

FROM base AS ros2
RUN dos2unix /scripts/*.sh
RUN /scripts/install-build-essential.sh
RUN /scripts/install-cmake.sh
RUN /scripts/install-ros2.sh

FROM ros2 AS zed-sdk
RUN /scripts/install-zed-sdk.sh

FROM zed-sdk AS opencv-cuda
RUN /scripts/install-opencv-cuda.sh

FROM opencv-cuda AS pip-packages
# run the normal pip packages
ENV PIP_DEFAULT_TIMEOUT=100
RUN python3 -m pip install --upgrade pip
RUN pip3 install --no-cache-dir --verbose --ignore-installed blinker
RUN pip3 install --no-cache-dir --verbose \
    flask \
    numpy \
    cupy-cuda12x \
    tqdm

FROM pip-packages AS final
ENV PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
ENV LANG=en_US.UTF-8

RUN mkdir -p /home/user/workspace
WORKDIR /home/user/workspace

ENTRYPOINT ["/bin/bash"]