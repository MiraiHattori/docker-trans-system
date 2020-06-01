#!/bin/bash

MY_WS=/userdir/my_ws/
CATKIN_WS=/userdir/catkin_ws/

cd ${MY_WS} && catkin clean -y

cd ${MY_WS}/src/osqp
cd build && make uninstall && git clean -fdx

cd ${MY_WS}/src/osqp-eigen
cd build && make uninstall && git clean -fdx

cd ${MY_WS}/src/isk_solver && git reset --hard HEAD && git clean -fdx
