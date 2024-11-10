FROM nvcr.io/nvidia/tensorrt:23.10-py3

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_DEFAULT_TIMEOUT=100
ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8

COPY ./scripts /scripts

RUN apt-get update && apt-get install -y dos2unix
RUN dos2unix /scripts/*.sh

# RUN /scripts/install-build-essential.sh

# RUN pip3 install --no-cache-dir --verbose --ignore-installed blinker
# RUN pip3 install --no-cache-dir --verbose \
#     # torch \
#     # torchvision \
#     numpy \
#     # scipy \
#     # scikit-learn \
#     # matplotlib \
#     # onnx \
#     # onnxruntime-gpu \
#     # ultralytics \
#     # cupy-cuda12x \
#     flask
# RUN pip3 install --upgrade pycuda

# RUN /scripts/install-cmake.sh
# # RUN /scripts/install-opencv-cuda.sh
# RUN /scripts/install-ros2.sh
RUN /scripts/install-zed-test.sh

ARG USERNAME=vscode
ARG USER_UID=999
ARG USER_GID=$USER_UID

# Create and switch to user 
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG dialout ${USERNAME}

# Set the default user to vscode
USER $USERNAME

# RUN python3 -m pip install --upgrade pip

# ENV PYTHONPATH="/home/$USERNAME/.local/lib/python3.10/site-packages:$PYTHONPATH"

# RUN sudo /scripts/install-opencv-cuda.sh

# ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# need to find the default python path and append after copying the export inside live container

# ENV PYTHONPATH=/usr/local/lib/python3.10/dist-packages:$PYTHONPATH

# ENV PYTHONPATH="$PYTHONUSERBASE/lib/python3.10/site-packages"

# Create workspace so that user own this directory
RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace

# RUN sudo apt-get update && sudo apt-get upgrade -y \
#     && sudo apt-get clean \
#     && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENTRYPOINT ["/bin/bash"]