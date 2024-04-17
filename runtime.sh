#!/bin/bash
# ---------------------------------------------------------------------------
# Build docker image and run ROS code for runtime or interactively with bash
# ---------------------------------------------------------------------------

# Initialise CMD as empty
CMD=""

# If an arg is defined, start contaier with bash
if [ -n "$1" ]; then
    CMD="bash"
fi

# Build docker image only up to base stage
DOCKER_BUILDKIT=1 docker build \
-t imu_humble \
-f Dockerfile --target runtime .

# Run docker image without volumes
docker run -it --rm --net host --privileged \
-v /dev/shm:/dev/shm \
-v /dev/imu-6:/dev/imu-front \
imu_humble $CMD