# FROM nvcr.io/nvidia/l4t-tensorrt:r10.3.0-runtime
# FROM nvcr.io/nvidia/l4t-tensorrt:r10.3.0-devel
FROM nvcr.io/nvidia/l4t-jetpack:r36.4.0 AS base
ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts
RUN apt-get update && apt-get install -y dos2unix

FROM base AS ros2
RUN dos2unix /scripts/*.sh && chmod +x /scripts/*.sh
RUN /scripts/install-build-essential.sh
RUN /scripts/install-cmake.sh
RUN /scripts/install-ros2.sh

FROM ros2 AS zed-sdk
RUN /scripts/install-zed-sdk-jetson.sh

FROM zed-sdk AS opencv-cuda
RUN /scripts/install-opencv-cuda-jetson.sh

FROM opencv-cuda AS pip-packages
RUN /scripts/install-pip-packages-jetson.sh

FROM pip-packages AS final
ENV PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
ENV LANG=en_US.UTF-8

RUN mkdir -p /home/user/workspace
WORKDIR /home/user/workspace

ENTRYPOINT ["/bin/bash"]