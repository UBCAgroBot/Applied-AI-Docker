FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts
RUN apt-get update && apt-get install -y dos2unix

RUN dos2unix /scripts/*.sh && chmod +x /scripts/*.sh
RUN /scripts/install-build-essential.sh
RUN /scripts/install-cmake.sh
RUN /scripts/install-ros2.sh

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN usermod -aG dialout ${USERNAME}
USER $USERNAME

RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN /scripts/install-rslidar-sdk.sh
RUN echo "source /home/$USERNAME/rslidar_build/install/setup.bash" >> ~/.bashrc

WORKDIR /home/$USERNAME/workspace
ENV LANG=en_US.UTF-8
ENV PYTHONWARNINGS="ignore"

ENTRYPOINT ["/bin/bash"]