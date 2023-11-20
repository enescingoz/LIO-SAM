#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
sudo touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -



# Get the current username
CURRENT_USER=$(whoami)
USER_HOME=$(eval echo ~$CURRENT_USER)

# Define the folder name
FOLDER_NAME="docker_home"
FOLDER_PATH="$USER_HOME/$FOLDER_NAME"

# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    # Create the folder
    mkdir -p "$FOLDER_PATH"
    if [ $? -eq 0 ]; then
        echo "Folder '$FOLDER_NAME' created successfully in $USER_HOME!"
    else
        echo "Failed to create folder '$FOLDER_NAME' in $USER_HOME."
    fi
else
    echo "Folder '$FOLDER_NAME' already exists in $USER_HOME."
fi


sudo docker run --gpus all --privileged --rm -it \
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