#!/bin/bash

source /userdir/scripts-on-docker/cnoid_env.bash
source /userdir/my_ws/devel/setup.bash
apt-get install -y ros-kinetic-eus-nlopt ros-kinetic-eus-qp ros-kinetic-eus-qpoases
roscd tennis/euslisp
roseus exec.l
