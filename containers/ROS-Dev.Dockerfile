FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /scripts
RUN apt-get update && apt-get install -y dos2unix

RUN dos2unix /scripts/*.sh
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
RUN python3 -m pip install --upgrade pip
RUN pip3 install --no-cache-dir --verbose flask tqdm requests opencv-python

ENV PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
ENV LANG=en_US.UTF-8

RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace
ENV LANG=en_US.UTF-8

ENTRYPOINT ["/bin/bash"]