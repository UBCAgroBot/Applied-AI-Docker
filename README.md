# Agrobot Container Repository

## Multi-Platform Builds:
```bash
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap

docker buildx build --platform linux/amd64,linux/arm64 -t agrobotappliedai/webdev-containers:latest --network=host --push .
docker buildx build --platform linux/amd64 -t agrobotappliedai/webdev-containers:latest --network=host --load .
```

## Running the container
```bash
docker run -it --rm --gpus all -v ~/Downloads:/home/usr/Downloads agrobotappliedai/ros-containers:latest --network=host 
``` 

