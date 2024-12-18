#!/usr/bin/env bash
set -ex

echo 'installing ros2'

locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

apt-get update -y && apt-get upgrade -y
apt-get update
apt-get install -y --no-install-recommends \
	gnupg2 \
	lsb-release \
	ca-certificates \
	locales \
	software-properties-common

add-apt-repository universe -y
apt-get update
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

apt-get update && apt-get upgrade -y
apt-get install ros-humble-ros-base python3-argcomplete ros-dev-tools -y
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source /opt/ros/humble/setup.bash
printenv | grep -i ROS

apt-get install -y --no-install-recommends \
	ros-humble-rosbridge-suite \
	python3-serial \
	python3-rosdep \
	ros-humble-cv-bridge

rosdep init && rosdep update
apt-get clean 
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ros2 doctor