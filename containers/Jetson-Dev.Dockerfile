FROM nvcr.io/nvidia/tensorrt:23.10-py3
ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts
RUN apt-get update && apt-get install -y dos2unix

RUN dos2unix /scripts/*.sh && chmod +x /scripts/*.sh
RUN /scripts/install-build-essential.sh
RUN /scripts/install-cmake.sh
RUN /scripts/install-ros2.sh

RUN /scripts/install-zed-sdk.sh

RUN /scripts/install-opencv-cuda.sh

RUN /scripts/install-pip-packages-jetson.sh

ENV PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
ENV LANG=en_US.UTF-8

RUN mkdir -p /home/user/workspace
WORKDIR /home/user/workspace

ENTRYPOINT ["/bin/bash"]