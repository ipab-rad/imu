FROM ros:humble-ros-base-jammy

# Install basic dev tools (And clean apt cache afterwards)
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
        apt -y --quiet --no-install-recommends install \
        # Command-line editor
        nano \
        # Ping network tools
        inetutils-ping \
        # Install Lord IMU driver pkg
        ros-$ROS_DISTRO-microstrain-inertial-driver \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS workspace folder
ENV ROS_WS /opt/ros_ws
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS

# Bring launch pkg into the docker image
ADD av_imu_launch $ROS_WS/src/av_imu_launch

# Source ROS setup for dependencies and build our code
RUN . /opt/ros/$ROS_DISTRO/setup.sh \
    && colcon build --symlink-install

# Add command to docker entrypoint to source newly compiled code when running docker container
RUN sed --in-place --expression \
      '$isource "$ROS_WS/install/setup.bash"' \
      /ros_entrypoint.sh

# Add sourcing local workspace command to bashrc for convenience when running interactively
RUN echo "source $ROS_WS/install/setup.bash" >> /root/.bashrc

# launch ros package
CMD ["ros2", "launch", "av_imu_launch", "av_imu.launch.xml"]
