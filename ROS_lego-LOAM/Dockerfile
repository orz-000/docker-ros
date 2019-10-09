# nvidia-docker build -t rosindustrial/ros-desktop-full:kinetic-nvidia9.0 .
#FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
FROM nvidia/cudagl:9.0-base-ubuntu16.04
LABEL maintainer "Shigeki"

RUN mkdir /home/shigeki

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# install GLX-Gears
RUN apt update && apt install -y --no-install-recommends mesa-utils x11-apps && rm -rf /var/lib/apt/lists/*

# Setup your sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'

# Set up your keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installation
RUN apt-get update && apt-get install -y --allow-unauthenticated \
    ros-kinetic-desktop-full \
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


RUN apt update && apt upgrade -y
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

#install lego-LOAM
RUN apt install wget -y
RUN wget -O /tmp/gtsam.zip https://github.com/borglab/gtsam/archive/4.0.0-alpha2.zip
WORKDIR /tmp
RUN unzip gtsam.zip -d /tmp
WORKDIR gtsam-4.0.0-alpha2
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make install

WORKDIR /home/shigeki/catkin_ws/src
RUN git clone https://github.com/facontidavide/LeGO-LOAM-BOR.git
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /home/shigeki/catkin_ws; catkin_make'

