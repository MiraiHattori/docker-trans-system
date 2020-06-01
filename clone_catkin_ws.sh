#!/bin/bash
mkdir -p catkin_ws/src
git clone --recursive https://github.com/fkanehiro/hrpsys-base.git catkin_ws/src/fkanehiro/hrpsys
git clone --recursive https://github.com/fkanehiro/openhrp3.git catkin_ws/src/fkanehiro/openhrp3
git clone --recursive https://github.com/start-jsk/rtmros_choreonoid.git catkin_ws/src/start-jsk/rtmros_choreonoid
git clone --recursive https://github.com/start-jsk/rtmros_common.git catkin_ws/src/start-jsk/rtmros_common
git clone --recursive https://github.com/start-jsk/rtmros_tutorials.git catkin_ws/src/start-jsk/rtmros_tutorials

hg clone https://bitbucket.org/crl/multisense_ros#3.4.9 catkin_ws/src/crl/multisense_ros

# private --recursive ones
git clone --recursive git@github.com:start-jsk/rtmros_hrp2.git catkin_ws/src/start-jsk/rtmros_hrp2
git clone --recursive git@github.com:jsk-ros-pkg/trans_system.git catkin_ws/src/jsk-ros-pkg/trans_system
