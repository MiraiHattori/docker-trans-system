#!/bin/bash

mkdir -p my_ws/src/isk_solver
git clone --recursive --branch add-tutorial git@github.com:future731/isk_solver my_ws/src/isk_solver
git clone --recursive --branch add-tutorial git@github.com:future731/isk_solver_sample my_ws/src/isk_solver_sample
git clone --recursive https://github.com/orocos/orocos_kinematics_dynamics my_ws/src/orocos_kinematics_dynamics
git clone --recursive https://github.com/oxfordcontrol/osqp my_ws/src/osqp
git clone --recursive https://github.com/robotology/osqp-eigen my_ws/src/osqp-eigen
