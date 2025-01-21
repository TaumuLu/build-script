#!/bin/bash

set -e

echo "Cleaning up Docker images, containers..."
# 清理停止的容器
docker container prune -f

# 清理未使用的镜像
docker image prune -f
echo "Docker cleanup completed."
