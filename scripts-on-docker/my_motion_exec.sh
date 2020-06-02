#!/bin/bash

source /userdir/scripts-on-docker/cnoid_env.bash
source /userdir/euslib/demo/m-hattori/catkin_ws/tennis/devel/setup.bash
apt-get install -y ros-kinetic-eus-nlopt ros-kinetic-eus-qp ros-kinetic-eus-qpoases
roscd baseball/euslisp
roseus exec.l
