#!/bin/bash

MY_WS=/userdir/my_ws/
KHI_WS=/khi_ws/
CMAKE_WS=/userdir/my_ws/devel/cmake_ws/



cd ${MY_WS}/src/osqp
mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=${MY_WS}/devel/osqp && make -j $(nproc) && make install


# for osqp-eigen cmake
if [ ! -e ${CMAKE_WS} ]; then
    mkdir ${CMAKE_WS}
fi

cd ${CMAKE_WS}
git clone --depth=1 https://gitlab.kitware.com/cmake/cmake.git
cd cmake
./bootstrap
make -j$(nproc)


cd ${MY_WS}/src/osqp-eigen
sed -i 's@find_package(Eigen3 3.2.92 REQUIRED)@find_package(Eigen3 REQUIRED)@' ${MY_WS}/src/osqp-eigen/cmake/OsqpEigenDependencies.cmake
sed -i 's@ Eigen3::Eigen)@)\ntarget_include_directories(${LIBRARY_TARGET_NAME} PUBLIC ${EIGEN3_INCLUDE_DIR})@' ${MY_WS}/src/osqp-eigen/CMakeLists.txt
mkdir -p build && cd build && ${CMAKE_WS}/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${MY_WS}/devel/osqp/lib/cmake && make -j $(nproc)
 # -DCMAKE_INSTALL_PREFIX=${MY_WS}/devel/osqp-eigen
cd ${MY_WS}
sed -i 's@set(orocos_kdl_DIR /home/riku/catkin_ws/jaxon_tutorial/devel/share/orocos_kdl/cmake)@set(orocos_kdl_DIR '${MY_WS}'/devel/share/orocos_kdl/cmake)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
sed -i 's@set(OSQP_DIR /home/riku/osqp)@set(OSQP_DIR '${MY_WS}'/src/osqp)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
sed -i 's@set(OSQP-EIGEN_DIR /home/riku/osqp-eigen)@set(OSQP-EIGEN_DIR '${MY_WS}'/src/osqp-eigen)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
# sed -i 's@set(OSQP-EIGEN_LIBRARIES ${OSQP-EIGEN_DIR}/build/libOsqpEigen.so)@set(OSQP-EIGEN_LIBRARIES ${OSQP-EIGEN_DIR}/build/lib/libOsqpEigen.so)@' ${MY_WS}/src/isk_solver/CMakeLists.txt
cd ${MY_WS}
source ${KHI_WS}/devel/setup.bash
catkin build --force-cmake || true

# TODO somehow these lines are needed
cd ${MY_WS}/src/osqp-eigen
cd build && cmake .. -DCMAKE_PREFIX_PATH=${MY_WS}/devel/osqp/lib/cmake && make -j $(nproc)

source ${MY_WS}/devel/setup.bash
catkin build --force-cmake
