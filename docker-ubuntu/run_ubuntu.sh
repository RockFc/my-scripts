CONTAINER_NAME="my-ubuntu"
IMAGE_NAME="my-ubuntu"
TAG=23.04.3
docker run -d -i -t -p 10001-10100:10001-10100/tcp -p 10001-10100:10001-10100/udp -p 8080:8080/tcp  --name $CONTAINER_NAME -v/Users/fuchao/Workspace:/workspace  $IMAGE_NAME:$TAG
