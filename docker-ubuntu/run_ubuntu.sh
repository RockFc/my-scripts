CONTAINER_NAME="my-ubuntu"
IMAGE_NAME="my-ubuntu"
TAG=23.04.$1
docker run -d -i -t --net=host --name $CONTAINER_NAME-$TAG -v/Users/fuchao/Workspace:/workspace  $IMAGE_NAME:$TAG
