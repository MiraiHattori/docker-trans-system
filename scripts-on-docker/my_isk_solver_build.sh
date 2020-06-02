#!/bin/bash

MY_WS=/userdir/my_ws/
CATKIN_WS=/userdir/catkin_ws/



cd ${MY_WS}/src/osqp
mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=${MY_WS}/devel/osqp && make -j $(nproc) && make install

cd ${MY_WS}/src/osqp-eigen
mkdir -p build && cd build && cmake .. -DCMAKE_PREFIX_PATH=${MY_WS}/devel/osqp/lib/cmake && make -j $(nproc)
 # -DCMAKE_INSTALL_PREFIX=${MY_WS}/devel/osqp-eigen
cd ${MY_WS}
sed -i 's@set(orocos_kdl_DIR /home/riku/catkin_ws/jaxon_tutorial/devel/share/orocos_kdl/cmake)@set(orocos_kdl_DIR '${MY_WS}'/devel/share/orocos_kdl/cmake)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
sed -i 's@set(OSQP_DIR /home/riku/osqp)@set(OSQP_DIR '${MY_WS}'/src/osqp)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
sed -i 's@set(OSQP-EIGEN_DIR /home/riku/osqp-eigen)@set(OSQP-EIGEN_DIR '${MY_WS}'/src/osqp-eigen)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
sed -i 's@set(OSQP-EIGEN_DIR /home/riku/osqp-eigen)@set(OSQP-EIGEN_DIR '${MY_WS}'/src/osqp-eigen)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
# sed -i 's@set(OSQP-EIGEN_LIBRARIES ${OSQP-EIGEN_DIR}/build/libOsqpEigen.so)@set(OSQP-EIGEN_LIBRARIES ${OSQP-EIGEN_DIR}/build/lib/libOsqpEigen.so)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
cd ${MY_WS}
source ${CATKIN_WS}/devel/setup.bash
catkin build --force-cmake || true

# TODO somehow these lines are needed
cd ${MY_WS}/src/osqp-eigen
cd build && cmake .. -DCMAKE_PREFIX_PATH=${MY_WS}/devel/osqp/lib/cmake && make -j $(nproc)

source ${MY_WS}/devel/setup.bash
catkin build --force-cmake
