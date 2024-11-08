# FROM nvcr.io/nvidia/l4t-tensorrt:r10.3.0-runtime
# FROM nvcr.io/nvidia/l4t-tensorrt:r10.3.0-devel
FROM nvcr.io/nvidia/l4t-jetpack:r36.4.0

ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts

RUN apt-get update && apt-get install -y dos2unix && python3 -m pip install --upgrade pip

RUN dos2unix /scripts/*.sh

RUN /scripts/install-build-essential.sh

RUN /scripts/install-cmake.sh

RUN /scripts/install-ros2.sh

RUN /scripts/install-zed-sdk-jetson.sh

RUN /scripts/install-opencv-cuda-jetson.sh

RUN /scripts/install-pip-packages-jetson.sh

ENTRYPOINT ["/bin/bash"]