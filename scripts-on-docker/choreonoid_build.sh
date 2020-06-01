#!/bin/bash
source ./scripts-on-docker/cnoid_env.bash
cd /userdir/choreonoid_ws/
sed -i -e 's@OPENRTM_VERSION STREQUAL "1.1.2"@OPENRTM_VERSION STREQUAL "1.1.0"@' choreonoid/CMakeLists.txt
sed -i -e 's@OPENRTM_VERSION VERSION_EQUAL "1.1.2"@OPENRTM_VERSION VERSION_EQUAL "1.1.0"@' choreonoid/CMakeLists.txt
sed -i -e 's@OPENRTM_VERSION VERSION_EQUAL "1.1.2"@OPENRTM_VERSION VERSION_EQUAL "1.1.0"@' choreonoid/CMakeLists.txt
# sed -i -e '1s@^@cmake_policy(SET CMP0057 NEW)\n@' choreonoid/cmake/ChoreonoidFindQt.cmake
./choreonoid/misc/script/install-requisites-ubuntu-16.04.sh
source /opt/ros/kinetic/setup.bash # for openrtm
cd choreonoid
mkdir build
cd build
cmake -DENABLE_CORBA=ON -DBUILD_CORBA_PLUGIN=ON -DBUILD_OPENRTM_PLUGIN=ON -DBUILD_HELLO_WORLD_SAMPLE=ON -DBUILD_SPRING_MODEL_SAMPLE=ON -DUSE_BUILTIN_CAMERA_IMAGE_IDL=ON -DCMAKE_INSTALL_PREFIX=/userdir/choreonoid_ws/devel ..
cmake .. -DCMAKE_INSTALL_PREFIX=${CNOID_INSTALL_DIR} -DOPENRTM_DIR=${CNOID_RTM_DIR} -DENABLE_INSTALL_RPATH=ON -DENABLE_CORBA=ON -DBUILD_CORBA_PLUGIN=ON -DBUILD_OPENRTM_PLUGIN=ON -DBUILD_HELLO_WORLD_SAMPLE=ON -DBUILD_SPRING_MODEL_SAMPLE=ON -DUSE_PYTHON3=OFF -DUSE_PYBIND11=OFF -DUSE_BUILTIN_CAMERA_IMAGE_IDL=ON
make install -j $(nproc)
