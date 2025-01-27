# 设置tag
CONTAINER_NAME="golang"
TAG="1.20.$1"

docker commit -m 'golang' -a 'fc' $CONTAINER_NAME $CONTAINER_NAME:$TAG
docker save -o $CONTAINER_NAME:$TAG.tar  $CONTAINER_NAME:$TAG
