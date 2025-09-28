# Agrobot Container Repository

## Building:
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t agrobotappliedai/ros-containers:latest -f ROS-Dev.Dockerfile . --network=host --push
```

## Running the container
```bash
docker run -it --rm --gpus all -v ~/Downloads:/home/usr/Downloads agrobotappliedai/ros-containers:latest --network=host
```