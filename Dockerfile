# 第一阶段：构建前端项目
FROM node:16 AS builder

# 设置工作目录
WORKDIR /app

# 将 package.json 和 package-lock.json 复制到容器中
COPY package.json ./

# 安装依赖
RUN npm install -g pnpm
RUN pnpm install

# 将项目文件复制到容器中
COPY . .

# 构建前端项目
RUN pnpm run build

# 第二阶段：使用 Nginx 作为 web 服务器
FROM nginx:latest

# 删除默认的 Nginx 配置文件
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义的 Nginx 配置文件
COPY nginx/default.conf /etc/nginx/conf.d/

# 将构建好的前端文件复制到默认的 Nginx 目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口 80
EXPOSE 80

# 启动 Nginx 服务器
CMD ["nginx", "-g", "daemon off;"]

