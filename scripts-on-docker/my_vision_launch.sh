#!/bin/bash

source /userdir/scripts-on-docker/cnoid_env.bash
source /userdir/my_ws/devel/setup.bash
roslaunch ball_orbit_estimator simulator.launch timestamp_str:=$(cat /userdir/logs/timestamp.txt)
