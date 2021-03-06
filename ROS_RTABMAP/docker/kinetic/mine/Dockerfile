# nvidia-docker build -t rosindustrial/ros-desktop-full:kinetic-nvidia9.0 .
#FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
FROM nvidia/cudagl:9.2-base-ubuntu16.04
LABEL maintainer "Shigeki"

ARG your_name

ENV DEBIAN_FRONTEND noninteractive

# see: https://gitlab.com/nvidia/opengl/tree/ubuntu18.04

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility

# install GLX-Gears
RUN apt update && apt install -y --no-install-recommends mesa-utils x11-apps && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'
# Set up your keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# Installation
RUN apt update && \
	echo "yes\n6\n" | apt install ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init
RUN rosdep update


RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

RUN apt update && apt install -y --allow-unauthenticated \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
   && rm -rf /var/lib/apt/lists/*


RUN apt update && apt upgrade -y 

#install emacs and openssl
RUN apt install -y bash-completion git build-essential emacs openssl

#python setup
RUN apt install python-pip python-dev build-essential -y 
RUN pip install --upgrade pip
RUN pip install --upgrade --force-reinstall pip==9.0.3
RUN pip install blockstack --upgrade
RUN python -m easy_install --upgrade pyOpenSSL
RUN pip install --upgrade cryptography

WORKDIR /root/

ARG CACHE_DATE=2016-01-01

RUN git clone https://github.com/introlab/rtabmap.git

# Build RTAB-Map project
RUN source /ros_entrypoint.sh && \
    cd rtabmap/build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && \
    rm -rf rtabmap && \
    ldconfig

RUN source /ros_entrypoint.sh && \
    mkdir -p catkin_ws/src && \
    cd catkin_ws/src && \
    catkin_init_workspace && \
    git clone https://github.com/introlab/rtabmap_ros.git && \
    cd .. && \
    catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/kinetic install && \
    cd && \
    rm -rf catkin_ws

ENV DEBIAN_FRONTEND dialog  
