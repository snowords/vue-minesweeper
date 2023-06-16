#!/bin/bash

# 拉取最新代码
git pull

# 重启 Docker Compose 服务
docker-compose up -d

# 清理旧容器和镜像（可选）
# docker system prune --all --force

