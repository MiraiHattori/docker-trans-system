#!/bin/bash
git clone --recursive https://github.com/future731/ball_state_msgs.git catkin_ws/src/ball_state_msgs

mkdir -p my_ws/src
git clone --recursive https://github.com/future731/ball_orbit_estimator.git my_ws/src/ball_orbit_estimator
