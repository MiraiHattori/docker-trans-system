#!/bin/bash
# TODO use wstool instead
mkdir -p catkin_ws/src
git clone --recursive https://github.com/fkanehiro/hrpsys-base.git catkin_ws/src/fkanehiro/hrpsys
git clone --recursive https://github.com/fkanehiro/openhrp3.git catkin_ws/src/fkanehiro/openhrp3
git clone --recursive https://github.com/start-jsk/rtmros_choreonoid.git catkin_ws/src/start-jsk/rtmros_choreonoid
git clone --recursive https://github.com/start-jsk/rtmros_common.git catkin_ws/src/start-jsk/rtmros_common
git clone --recursive https://github.com/start-jsk/rtmros_tutorials.git catkin_ws/src/start-jsk/rtmros_tutorials

git clone --recursive https://github.com/carnegierobotics/multisense_ros -b 3.4.9 catkin_ws/src/carnegierobotics/multisense_ros

# private --recursive ones
git clone --recursive git@github.com:start-jsk/rtmros_hrp2.git catkin_ws/src/start-jsk/rtmros_hrp2
git clone --recursive git@github.com:jsk-ros-pkg/trans_system.git catkin_ws/src/jsk-ros-pkg/trans_system
