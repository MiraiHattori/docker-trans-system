#!/bin/bash
source /userdir/my_ws/devel/setup.bash
rosrun rviz rviz -d $(rospack find tennis)/config/tennis.rviz
