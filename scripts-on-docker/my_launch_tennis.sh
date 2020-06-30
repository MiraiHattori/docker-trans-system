#!/bin/bash

source /userdir/scripts-on-docker/cnoid_env.bash
source /userdir/my_ws/devel/setup.bash
apt-get purge -y ros-kinetic-openhrp3 ros-kinetic-hrpsys-ros-bridge
rtmlaunch tennis forehand.launch
