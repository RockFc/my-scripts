FROM ubuntu:24.04

# 设置环境变量
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装基础系统和开发工具
RUN apt-get update && apt-get install -y \
    # 系统工具
    sudo curl wget \
    # 开发工具
    git build-essential gcc g++ gdb cmake make \
    autoconf automake libtool pkg-config \
    valgrind cppcheck clang lldb \
    # 网络和调试工具
    openssh-server net-tools iputils-ping \
    # 编辑器和工具
    vim nano tree htop \
    # Python
    python3 python3-pip \
    # Docker 客户端（简化版）
    docker.io \
    # 开发库
    libboost-all-dev libssl-dev \
    zlib1g-dev libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 更新其他依赖
RUN apt-get update --fix-missing && \
    apt-get install -y \
    libsqlite3-dev \
    libpq-dev \
    libmysqlclient-dev \
    libzstd-dev \
    && apt-get clean

# 配置 SSH
RUN mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# 安装 Docker Compose V2 插件 (Linux)
RUN apt-get update && \
    apt-get install -y curl jq && \
    curl -SL https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# 设置工作目录
WORKDIR /workspace

# 启动脚本
CMD bash -c " \
    echo 'root:123456' | chpasswd && \
    /usr/sbin/sshd -D & \
    echo 'Development container 24 ready!' && \
    echo 'G++ version:'; g++ --version | head -1 && \
    echo 'CMake version:'; cmake --version | head -1 && \
    bash"