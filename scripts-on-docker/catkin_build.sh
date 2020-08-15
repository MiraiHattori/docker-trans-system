#!/bin/bash

source /opt/ros/kinetic/setup.bash
source scripts-on-docker/cnoid_env.bash
cd /userdir/catkin_ws
touch src/start-jsk/rtmros_tutorials/hrpsys_gazebo_tutorials/CATKIN_IGNORE
touch src/jsk-ros-pkg/trans_system/jaxon_gazebo_ros_plugins/CATKIN_IGNORE
touch src/jsk-ros-pkg/trans_system/multisense_sl_gazebo_ros_plugin/CATKIN_IGNORE

wstool update -t src
rosdep install -y -r --from-paths --ignore-src .

# apt-get purge -y ros-kinetic-openhrp3 ros-kinetic-hrpsys
catkin build -c
