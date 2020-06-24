#!/bin/bash

source /userdir/catkin_ws/devel/setup.bash
cd /userdir/catkin_ws
catkin build ball_state_msgs
source /userdir/catkin_ws/devel/setup.bash
apt-get install -y ros-kinetic-nlopt
apt-get install -y libgsl-dev # for baseball
cd /userdir/my_ws/
catkin b
source /userdir/my_ws/devel/setup.bash
cd /userdir/my_ws/src
catkin build -c
roscd hrpsys                      && git remote add future731 https://github.com/future731/hrpsys-base.git
roscd hrpsys                      && git remote update -p && git reset --hard HEAD && git checkout bsp-modification
roscd hrpsys_ros_bridge           && git remote add future731 https://github.com/future731/rtmros_common.git
roscd hrpsys_ros_bridge           && git remote update -p && git reset --hard HEAD && git checkout bsp-modification
roscd hrpsys_choreonoid_tutorials && git remote add future731 https://github.com/future731/rtmros_choreonoid.git
roscd hrpsys_choreonoid_tutorials && git remote update -p && git reset --hard HEAD && git clean -fdx && git checkout add_pointgrey_camera
echo "configure_file(\${PROJECT_SOURCE_DIR}/config/JAXON_RED_FOREHAND.cnoid.in \${PROJECT_SOURCE_DIR}/config/JAXON_RED_FOREHAND.cnoid @ONLY)" >> $(rospack find hrpsys_choreonoid_tutorials)/CMakeLists.txt
source /userdir/my_ws/devel/setup.sh
rosrun tennis choreonoid_settings.sh

source /userdir/catkin_ws/devel/setup.bash
roscd hrpsys_choreonoid_tutorials && catkin build --force-cmake
