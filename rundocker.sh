#!/usr/bin/bash
#
# File  : rundocker.sh
# Brief : Build and run a docker image
# Author: Lyndon Hill
# Date  : 2025.10.01
#
# Usage:  rundocker.sh (image name) (workspace)
#  where,
#   image name = the name of the docker image
#   workspace  = path to be mounted at /work inside the image
#
# The docker image name will be tagged under the namespace "mukoan"

if [ "$#" -ne 2 ]; then
    echo "Usage: rundocker.sh image workspace"
    exit 1
fi

set -e

IMAGE=$1
WORKSPACE=$2

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
DISPLAY_ARGS="--volume=$XSOCK:$XSOCK:rw --volume=$XAUTH:$XAUTH:rw --env=XAUTHORITY=$XAUTH --env=DISPLAY=$DISPLAY"
CUDA_ARGS="--gpus all -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics"
PORT_MAPS="-p 8989:8080"

# Build the docker image
docker build -f ${IMAGE}.Dockerfile -t mukoan/${IMAGE} .

# Run the docker container
docker run ${PORT_MAPS} --rm -w /work -v "$WORKSPACE:/work" ${DISPLAY_ARGS} ${CUDA_ARGS} -it mukoan/${IMAGE}
