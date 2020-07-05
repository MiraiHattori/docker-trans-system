#!/bin/bash

OPT=${DOCKER_OPTION:-""}
iname=${DOCKER_IMAGE:-"isk-solver:m-hattori"}
cname=${DOCKER_CONTAINER:-"isk-solver"}

DEFAULT_USER_DIR="$(pwd)"


VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch"}

if [ "${DOCKER_ROS_IP}" == "" ]; then
    export DOCKER_ROS_IP=localhost
fi

NET_OPT="--net=host --env=DOCKER_ROS_IP --env=DOCKER_ROS_MASTER_URI"

xhost +si:localuser:root

docker rm ${cname}

docker run ${OPT} \
    --privileged \
    --gpus=all \
    ${NET_OPT} \
    --env="DOCKER_ROS_SETUP=/catkin_ws/devel/setup.bash" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}
