FROM ubuntu:20.04

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

# 升级 GCC/G++ 到 11
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && apt-get install -y gcc-11 g++-11 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

# 升级 CMake 到 3.31
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.0/cmake-3.31.0-Linux-x86_64.tar.gz && \
    tar -xzvf cmake-3.31.0-Linux-x86_64.tar.gz && \
    mv cmake-3.31.0-*/ /usr/local/cmake-3.31 && \
    ln -s /usr/local/cmake-3.31/bin/* /usr/local/bin/ && \
    rm -rf cmake-3.31.0-Linux-x86_64.tar.gz

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

# 设置工作目录
WORKDIR /workspace

# 启动脚本
CMD bash -c " \
    echo 'root:123456' | chpasswd && \
    /usr/sbin/sshd -D & \
    echo 'Development container ready! SSH: ssh root@localhost -p 2222 (password: 123456)' && \
    bash"