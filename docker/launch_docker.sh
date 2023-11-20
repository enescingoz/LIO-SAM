#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -



# Check if the folder exists
if [ ! -d "$HOME/docker_home" ]; then
    # Create the folder
    mkdir "$HOME/docker_home"
    if [ $? -eq 0 ]; then
        echo "Folder 'docker_home' created successfully!"
    else
        echo "Failed to create folder 'docker_home'."
    fi
else
    echo "Folder 'docker_home' already exists."
fi


docker run --gpus all --privileged --rm -it \
           --volume=$XSOCK:$XSOCK:rw \
           --volume=$XAUTH:$XAUTH:rw \
           --volume=$HOME/docker_home:/root/docker_home \
           --shm-size=1gb \
           --env="XAUTHORITY=${XAUTH}" \
           --env="DISPLAY=${DISPLAY}" \
           --env=TERM=xterm-256color \
           --env=QT_X11_NO_MITSHM=1 \
           --net=host \
           liosam-humble-jammy \
           bash -c "cd /root/ros2_ws/ && bash"