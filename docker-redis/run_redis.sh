#rm -rf redis-conf
#rm -rf redis-data
#mkdir -p redis-conf
#mkdir -p redis-data

docker run --restart=always -p 6380:6379 --name my-redis -v $PWD/redis-conf:/etc/redis/ -v $PWD/redis-data:/data -d  redis:latest redis-server /etc/redis/redis.conf

