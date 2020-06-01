# FROM osrf/ros:kinetic-desktop-full
FROM yoheikakiuchi/ros_gl:16.04

RUN apt-get -q -qq update && apt-get upgrade -q -qq -y

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display,compat32

ENV ROBOT JAXON_RED
# copied from choreonoid install-requisites-ubuntu-16.04.sh
RUN apt-get -q -qq update && apt-get upgrade -q -qq -y && apt-get install -q -qq -y build-essential \
cmake-curses-gui \
libboost-all-dev \
libeigen3-dev \
libeigen3-doc \
libxfixes-dev \
libyaml-dev \
gettext \
zlib1g-dev \
libjpeg-dev \
libpng12-dev \
qt5-default \
libqt5x11extras5-dev \
libqt5svg5-dev \
qt5-style-plugins \
python3-dev \
python3-numpy \
python2.7-dev \
python-numpy \
libassimp-dev \
libsdformat4-dev \
libogre-1.9-dev \
libode-dev \
libomniorb4-dev \
libcos4-dev \
omniidl \
omniorb-nameserver \
python-omniorb \
omniidl-python \
uuid-dev \
libpulse-dev \
libsndfile1-dev \
libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev \
lua5.3 \
liblua5.3-dev \
lua-posix

RUN apt-get -q -qq update && apt-get upgrade -q -qq -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get autoclean -y && apt-get install -q -qq -y fsharp libncurses5-dev  libsdl1.2-dev omniorb omniidl omniorb-idl omniorb-nameserver libomniorb4-dev doxygen libglew-dev net-tools ffmpeg automake python-coverage libv4l-dev protobuf-compiler python-mock xvfb python3-catkin-pkg python3-mock python3-pyqt5 python3-sip-dev python3-empy python3-nose python3-rospkg libtool libtool-bin && apt-get clean && rm -rf /var/lib/apt/lists
RUN apt-get -q -qq update && apt-get upgrade -q -qq -y && apt-get install -q -qq -y ros-kinetic-jsk-tilt-laser ros-kinetic-ivcon mono-complete ros-kinetic-voice-text ros-kinetic-pr2-teleop ros-kinetic-rospatlite ros-kinetic-jsk-tools ros-kinetic-convex-decomposition ros-kinetic-multisense-bringup ros-kinetic-sound-play ros-kinetic-rosserial ros-kinetic-pr2-controllers-msgs ipython ros-kinetic-collada-urdf ros-kinetic-jsk-perception ros-kinetic-robot-pose-ekf ros-kinetic-collada-urdf-jsk-patch ros-kinetic-euscollada ros-kinetic-pr2-msgs ros-kinetic-jsk-pcl-ros ros-kinetic-openrtm-aist ros-kinetic-moveit-commander ros-kinetic-opencv-apps ros-kinetic-roseus ros-kinetic-openrtm-aist-python ros-kinetic-rtshell ros-kinetic-euslisp ros-kinetic-openhrp3 ros-kinetic-pr2eus ros-kinetic-pr2-computer-monitor ros-kinetic-leap-motion libpng12-dev ros-kinetic-jsk-footstep-planner ros-kinetic-jsk-footstep-controller ros-kinetic-nextage-gazebo ros-kinetic-nextage-description ros-kinetic-effort-controllers ros-kinetic-jsk-calibration ros-kinetic-hironx-ros-bridge ros-kinetic-nextage-ros-bridge ros-kinetic-gazebo-ros-control
