# nvidia-docker build -t rosindustrial/ros-desktop-full:kinetic-nvidia9.0 .
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer "Koby"

RUN mkdir /home/shigeki

# nvidia-docker hooks accerareted graphics
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# Setup your sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'

# Set up your keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# Installation
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init
RUN rosdep update


RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

RUN apt-get update && apt-get install -y \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


RUN apt update && apt upgrade -y
RUN mkdir -p /home/shigeki/catkin_ws/src
RUN cd /home/shigeki/catkin_ws/ && catkin_make

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
RUN cd /tmp && unzip gtsam.zip -d /tmp
RUN cd /tmp/gtsam-4.0.0-alpha2/
RUN mkdir build && cd build
RUN cmake ..
RUN make install

RUN cd /home/shigeki/catkin_ws/src && git clone https://github.com/RobustFieldAutonomyLab/LeGO-LOAM.git
RUN cd /home/shigeki/catkin_ws && catkin_make


