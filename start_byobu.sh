#!/bin/bash

byobu new-window -n choreonoid bash -c ./my_launch_tennis.sh
sleep 10
byobu new-window -n eus bash -c ./my_motion_exec.sh
byobu new-window -n vision bash -c ./my_vision_launch.sh
byobu new-window -n rviz bash -c ./my_rviz.sh
