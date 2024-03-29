#!/bin/bash
###############################################################################
# Build docker dev stage and add local code for live development              #
###############################################################################

# Build docker image up to dev stage
DOCKER_BUILDKIT=1 docker build \
-t imu_humble \
-f Dockerfile --target dev .

# Run docker image with local code volumes for development
docker run -it --rm --net host \
-v /dev/shm:/dev/shm \
-v ./av_imu_launch:/opt/ros_ws/src/av_imu_launch \
imu_humble
