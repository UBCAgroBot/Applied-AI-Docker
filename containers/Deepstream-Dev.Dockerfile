FROM nvcr.io/nvidia/deepstream:7.0-triton-multiarch

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all,compute,video,graphics,utility

RUN apt update

RUN apt install -y --no-install-recommends ca-certificates curl build-essential pkg-config libssl-dev libxtensor-dev plocate libeigen3-dev libgtest-dev && rm -rf /var/lib/apt/lists/*

# Install OpenCV
RUN apt update && apt install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libtbb2 
RUN mkdir /tmp/workspace
WORKDIR /tmp/workspace
RUN curl -L https://github.com/opencv/opencv/archive/4.10.0.zip -o opencv-4.10.0.zip && unzip opencv-4.10.0.zip && rm opencv-4.10.0.zip
RUN curl -L https://github.com/opencv/opencv_contrib/archive/4.10.0.zip -o opencv_contrib-4.10.0.zip && unzip opencv_contrib-4.10.0.zip && rm opencv_contrib-4.10.0.zip
RUN cd opencv-4.10.0/ && mkdir release && cd release/
WORKDIR /tmp/workspace/opencv-4.10.0/release/
RUN cmake -D WITH_CUDA=ON -D WITH_CUDNN=ON -D CUDA_ARCH_BIN="8.7" -D CUDA_ARCH_PTX="" \
          -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.10.0/modules \
          -D WITH_GSTREAMER=ON -D WITH_LIBV4L=ON -D BUILD_opencv_python3=OFF -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
RUN make -j$(nproc) && make install

# Install RidgeRun Gstreamer Plugins
WORKDIR /tmp/workspace
RUN git clone https://github.com/RidgeRun/gst-interpipe.git
RUN apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gtk-doc-tools 
WORKDIR /tmp/workspace/gst-interpipe
RUN ./autogen.sh --libdir /usr/lib/$(uname -m)-linux-gnu/ && make && make check && make install
WORKDIR /tmp/workspace
RUN git clone https://github.com/RidgeRun/gst-perf.git
WORKDIR /tmp/workspace/gst-perf
RUN ./autogen.sh && ./configure --prefix /usr/ --libdir /usr/lib/$(uname -m)-linux-gnu/ && make && make install

ENV DS=/opt/nvidia/deepstream/deepstream-7.0
ENV LD_LIBRARY_PATH="$DS/lib:/usr/local/cuda/compat:/usr/local/cuda/lib64:/usr/lib/aarch64-linux-gnu:${LD_LIBRARY_PATH:-}"
ENV GST_PLUGIN_PATH="/usr/lib/aarch64-linux-gnu/gstreamer-1.0/deepstream:/usr/local/lib/aarch64-linux-gnu/gstreamer-1.0"
RUN rm -f ~/.cache/gstreamer-1.0/registry.*
ENV GST_REGISTRY_REUSE_PLUGIN_SCANNER=0

# Install Python Deps
RUN apt install -y python3-pip python3-venv && python3 -m venv ~/myenv
RUN source ~/myenv/bin/activate && pip3 install opencv-contrib-python pyyaml scipy && deactivate

RUN updatedb

CMD ["/bin/bash"]