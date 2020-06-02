#!/bin/bash

MY_WS=/userdir/my_ws/
CATKIN_WS=/userdir/catkin_ws/

cd ${MY_WS} && catkin clean -y

cd ${MY_WS}/src/osqp/build && make uninstall
cd ${MY_WS}/src/osqp && rm -rf build && git clean -fdx

cd ${MY_WS}/src/osqp-eigen/build && make uninstall
cd ${MY_WS}/src/osqp-eigen && rm -rf build && git clean -fdx

cd ${MY_WS}/src/isk_solver && git reset --hard HEAD && git clean -fdx
