# nvidia-docker build -t rosindustrial/ros-desktop-full:kinetic-nvidia9.0 .
#FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
FROM nvidia/cudagl:9.0-base-ubuntu18.04
LABEL maintainer "Shigeki"

ARG your_name

# see: https://gitlab.com/nvidia/opengl/tree/ubuntu18.04

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility

# install GLX-Gears
RUN apt update && apt install -y --no-install-recommends mesa-utils x11-apps && rm -rf /var/lib/apt/lists/*

# Setup your sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'

# Set up your keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installation
RUN apt-get update && apt-get install -y --allow-unauthenticated \
    ros-melodic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init
RUN rosdep update


RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

RUN apt-get update && apt-get install -y --allow-unauthenticated \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


RUN apt update && apt upgrade -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/shigeki/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /home/shigeki/catkin_ws; catkin_make'

#install emacs and openssl
RUN apt-get install emacs -y
RUN apt-get -y install bash-completion git build-essential emacs
RUN apt-get install openssl -y

#python setup
RUN apt-get install python-pip python-dev build-essential -y 
RUN pip install --upgrade pip
RUN pip install --upgrade --force-reinstall pip==9.0.3
RUN pip install blockstack --upgrade
RUN python -m easy_install --upgrade pyOpenSSL
RUN pip install --upgrade cryptography

# Prerequisites
# ENV USER=$your_name
RUN adduser $your_name
RUN curl http://ceres-solver.org/ceres-solver-1.14.0.tar.gz --output ceres-solver-1.14.0.tar.gz
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
RUN tar zxf ceres-solver-1.14.0.tar.gz && mkdir ceres-bin && cd ceres-bin && cmake ../ceres-solver-1.14.0 && make -j3 && make install
# USER $yourname
# RUN mkdir -p /workspace && chmod -R 777 /workspace
# COPY --chown=1000:1000 . /workspace/src/
COPY . /home/your_name/src/
WORKDIR /home/your_name
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make -DCMAKE_BUILD_TYPE=Release"
