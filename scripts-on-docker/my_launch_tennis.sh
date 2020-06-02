#!/bin/bash

source /userdir/scripts-on-docker/cnoid_env.bash
source /userdir/catkin_ws/devel/setup.bash
apt-get purge -y ros-kinetic-openhrp3 ros-kinetic-hrpsys-ros-bridge
rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch TASK:=FOREHAND
