FROM nvcr.io/nvidia/l4t-jetpack:r36.3.0 AS base
ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts
RUN apt-get update && apt-get install -y dos2unix

FROM base AS ros2
RUN dos2unix /scripts/*.sh && chmod +x /scripts/*.sh
RUN /scripts/install-build-essential.sh
RUN /scripts/install-cmake.sh
RUN /scripts/install-ros2.sh

ENV PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
ENV LANG=en_US.UTF-8

RUN mkdir -p /home/user/workspace
WORKDIR /home/user/workspace
RUN source /opt/ros/humble/setup.bash && ros2 doctor

ENTRYPOINT ["/bin/bash"]