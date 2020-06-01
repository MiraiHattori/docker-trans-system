#!/bin/bash

CATKIN_WS=/userdir/catkin_ws

cd ${CATKIN_WS}
catkin clean -y

for f in fkanehiro/hrpsys fkanehiro/openhrp3 start-jsk/rtmros_choreonoid start-jsk/rtmros_common start-jsk/rtmros_hrp2 start-jsk/rtmros_tutorials jsk-ros-pkg/trans_system # crl/multisense_ros
do
    cd ${CATKIN_WS} && cd src/${f} && git clean -fdx && cd ${CATKIN_WS}
done

rm -rf src/start-jsk/rtmros_choreonoid/jvrc_models/model
