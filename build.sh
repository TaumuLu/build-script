#!/bin/bash

set -e

# 开始执行脚本
echo "========================================================================"
echo "🚀  build script starts to execute  🚀"
echo "========================================================================"

CURRENT_DIR=$(basename $(pwd))
echo "Current directory name: $CURRENT_DIR"

# 定义变量
DOCKER_IMAGE="${1:-$CURRENT_DIR}"
DOCKER_TAG="${2:-latest}"
# DOCKER_REGISTRY="my-docker-registry.com"  # Docker Registry 地址（如果使用私有 registry）

# 检查必需参数
for param in DOCKER_IMAGE DOCKER_TAG; do
  if [ -z "${!param}" ]; then
    echo "Error: $param is required"
    exit 1
  fi
done


# # 切换到工作目录
# if [ -z "$WORKSPACE" ]; then
#   echo "WORKSPACE 变量不存在，使用当前目录"
#   WORKSPACE=$(pwd)  # 如果 WORKSPACE 不存在，使用当前目录
# else
#   echo "WORKSPACE 变量存在，目录为: $WORKSPACE"
# fi

docker --version

# 如果需要登录 Docker Registry，使用以下命令（如果需要的话）
# docker login -u username -p password $DOCKER_REGISTRY

# 停止并移除现有的同名容器
docker ps -q --filter "name=$DOCKER_IMAGE" | xargs -r docker stop | xargs -r docker rm

# 清理掉镜像垃圾
echo "Cleaning up Docker images, containers..."
# 清理停止的容器
docker container prune -f
# 清理未使用的镜像
docker image prune -f
echo "Docker cleanup completed."

# 构建 Docker 镜像
docker build --no-cache -t $DOCKER_IMAGE:$DOCKER_TAG .

# 运行新的 Docker 容器
docker run -d -p 8080:80 --name $DOCKER_IMAGE $DOCKER_IMAGE:$DOCKER_TAG

# 如果需要推送 Docker 镜像到 Docker Registry
# docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_REGISTRY/$DOCKER_IMAGE:$DOCKER_TAG
# docker push $DOCKER_REGISTRY/$DOCKER_IMAGE:$DOCKER_TAG

# 结束执行脚本
echo "========================================================================"
echo "✅  build script execution completed  ✅"
echo "========================================================================"
