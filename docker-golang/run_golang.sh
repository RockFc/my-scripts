CONTAINER_NAME="golang"
IMAGE_NAME="golang"
TAG=1.20-bullseye
docker run -d -i -t -p 8880:80/tcp  --name $CONTAINER_NAME -v/Users/fuchao/Workspace/go:/go  $IMAGE_NAME:$TAG
