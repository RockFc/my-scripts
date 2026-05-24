#!/bin/bash

# 1. Define network names
NETWORKS=("dev-net" "ai-net")

echo -e "\033[36mChecking Docker Backbone Networks...\033[0m"

# 2. Loop and check/create
for NET in "${NETWORKS[@]}"; do
    # Check if network exists
    if docker network ls --format "{{.Name}}" | grep -q "^${NET}$"; then
        echo -e "\033[32m[OK] Network already exists: ${NET}\033[0m"
    else
        echo -e "\033[33m[INFO] Network not found, creating: ${NET} ...\033[0m"
        docker network create "${NET}" > /dev/null
        if [ $? -eq 0 ]; then
            echo -e "\033[32m[SUCCESS] Created network: ${NET}\033[0m"
        else
            echo -e "\033[31m[ERROR] Failed to create network: ${NET}\033[0m"
        fi
    fi
done

echo -e "\033[90m----------------------------------------------\033[0m"

# 3. Show final status
echo -e "\033[36mCurrent active networks:\033[0m"
docker network ls --filter "name=dev-net" --filter "name=ai-net"