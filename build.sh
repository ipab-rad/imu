#!/bin/bash
###############################################################################
# Build docker full image but run interactively with bash for inspection      #
###############################################################################

# Build docker image only up to base stage
DOCKER_BUILDKIT=1 docker build \
-t imu_humble \
-f Dockerfile --target build .

# Run docker image without volumes
docker run -it --rm --net host \
-v /dev/shm:/dev/shm \
imu_humble bash
