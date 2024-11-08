FROM nvcr.io/nvidia/tensorrt:23.10-py3

ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts

RUN apt-get update && apt-get install -y dos2unix && python3 -m pip install --upgrade pip

RUN dos2unix /scripts/*.sh

RUN /scripts/install-build-essential.sh

RUN /scripts/install-cmake.sh

RUN /scripts/install-ros2.sh

RUN /scripts/install-zed-sdk.sh

RUN /scripts/install-opencv-cuda.sh

RUN /scripts/install-pip-packages.sh

ARG USERNAME=vscode
ARG USER_UID=999
ARG USER_GID=$USER_UID

# Create and switch to user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user to vscode
USER $USERNAME

# Create workspace so that user own this directory
RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace

ENV LANG=en_US.UTF-8

ENTRYPOINT ["/bin/bash"]