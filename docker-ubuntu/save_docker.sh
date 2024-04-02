# 设置tag
CONTAINER_NAME="my-ubuntu"
TAG="23.04.$1"

docker commit -m 'my-ubuntu' -a 'fc' $CONTAINER_NAME $CONTAINER_NAME:$TAG
docker save -o $CONTAINER_NAME:$TAG.tar  $CONTAINER_NAME:$TAG
