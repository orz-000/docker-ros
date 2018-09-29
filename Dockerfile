FROM ros:kinetic
MAINTAINER Koby
RUN apt update && apt install -y
# make catkin workspace
RUN apt-get install emacs -y
RUN apt-get -y install bash-completion git build-essential emacs
#RUN rosdep init
RUN HOME=/home/ros rosdep update
RUN  mkdir -p ~/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_init_workspace ~/catkin_ws/src'
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd ~/catkin_ws; catkin_make'
#RUN  cd ~/catkin_ws/

#RUN  ["/bin/bash", "-c", "catkin_make"]

#install vlp16_software
RUN apt-get install -y ros-kinetic-velodyne
#install loam_slam
RUN cd ~/catkin_ws/src/
RUN git clone https://github.com/laboshinl/loam_velodyne.git
RUN cd ~/catkin_ws
RUN rosdep install --from-paths ~/catkin_ws/src --ignore-src --rosdistro kinetic -y
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd ~/catkin_ws; catkin_make'
RUN /bin/bash -c 'source ~/catkin_ws/devel/setup.bash'

#install rviz
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y ros-kinetic-rviz
