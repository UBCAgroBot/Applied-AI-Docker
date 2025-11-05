# Agrobot Container Repository

## Building:
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t agrobotappliedai/ros-containers:latest -f ROS-Dev.Dockerfile . --network=host --push
```

## Running the container
```bash
docker run -it --rm --gpus all -v ~/Downloads:/home/usr/Downloads agrobotappliedai/ros-containers:latest --network=host 
``` 

## Running DeepStream Container:
```bash
#!/bin/bash

docker run -it --rm --network=host --runtime nvidia --ipc=host \
  --device /dev/dri \
  --device /dev/nvmap \
  --device /dev/nvhost-ctrl-gpu \
  --device /dev/nvhost-prof-gpu \
  --device /dev/nvhost-gpu \
  -v ~/gstreamer-pipeline-testing:/gstreamer-pipeline-testing \
  -w /gstreamer-pipeline-testing \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=compute,video,graphics,utility \
  attempt:latest
```

## Jetson Power:
```bash
sudo jetson-clocks
sudo nvpmodel -m 0
```