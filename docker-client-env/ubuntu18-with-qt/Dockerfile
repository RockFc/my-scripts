FROM ubuntu:18.04

LABEL maintainer="your-team"
LABEL description="C++ development environment based on Ubuntu 18.04"

# 设置非交互模式，避免 apt 安装时卡住
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 换国内源（加速 apt）
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装基础开发工具
RUN apt-get update && apt-get install -y \
    # 编译工具
    build-essential \
    cmake \
    make \
    ninja-build \
    # 版本控制
    git \
    # 调试工具
    gdb \
    valgrind \
    # 常用工具
    vim \
    wget \
    curl \
    pkg-config \
    # 常用开发库
    libboost-all-dev \
    libssl-dev \
    zlib1g-dev \
    libsnappy-dev \
    liblz4-dev \
    libzstd-dev \
    libbrotli-dev \ 
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libdrm-dev \
    libgles2-mesa-dev \
    # 清理缓存，减小镜像体积
    && apt-get clean \
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

# 设置工作目录
WORKDIR /workspace

# 默认进入 bash
CMD ["/bin/bash"]
