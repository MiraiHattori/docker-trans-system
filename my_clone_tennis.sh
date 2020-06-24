#!/bin/bash
git clone --recursive https://github.com/future731/ball_state_msgs.git catkin_ws/src/ball_state_msgs

mkdir -p my_ws/src
git clone --recursive https://github.com/future731/ball_orbit_estimator.git my_ws/src/ball_orbit_estimator
git clone --recursive https://github.com/jsk-ros-pkg/jsk_control.git my_ws/src/jsk_control
git clone --recursive https://github.com/future731/optmotiongen_sample.git my_ws/src/optmotiongen_sample
