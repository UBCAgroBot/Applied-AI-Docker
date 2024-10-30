# Agrobot Container Repository

This repository contains the Dockerfile and the necessary files to build the Agrobot container.


## Building the container

To build the container, you need to have Docker installed on your machine. You can download Docker from [here](https://www.docker.com/products/docker-desktop).

Once you have Docker installed, you can build the container by running the following command:

```bash
docker build -t agrobot .
```

This command will build the container and tag it with the name `agrobot`.

## Running the container

To run the container, you can use the following command:

```bash
docker run -it --rm agrobot
```

This command will run the container in interactive mode and remove it once you exit the container.

## Running the container with a volume

(confluence guides)