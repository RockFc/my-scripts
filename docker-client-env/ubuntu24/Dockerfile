# Dockerfile
FROM ubuntu:24.04

# 设置环境变量
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 换源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
sed -i 's@//.*security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources

# 安装基础系统和开发工具
RUN apt-get update && apt-get install -y --fix-missing \
    # 系统工具
    sudo curl wget \
    # 开发工具
    git build-essential gcc g++ gdb cmake make \
    autoconf automake libtool pkg-config \
    valgrind cppcheck clang lldb \
    # 网络和调试工具
    openssh-server openssh-client net-tools iputils-ping \
    # 编辑器和工具
    vim nano tree htop \
    # Python
    python3 python3-pip \
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

# 添加 GitHub 到 known_hosts，避免第一次连接需要手动确认
RUN mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    chmod 700 /root/.ssh

# 配置 Git 全局设置
RUN git config --global user.name "RockFc" && \
    git config --global user.email "769357879@qq.com" && \
    git config --global core.editor "vim" && \
    git config --global init.defaultBranch main && \
    git config --global pull.rebase false && \
    git config --global --add safe.directory '*'

# 设置工作目录
WORKDIR /workspace

# 启动脚本
CMD bash -c " \
    echo 'root:123456' | chpasswd && \
    # 处理 SSH key：从挂载目录复制并修复权限（兼容 Linux/Windows 宿主机）
    if [ -d /root/.ssh-host ]; then \
        echo 'Copying SSH keys from host...' && \
        cp /root/.ssh-host/* /root/.ssh/ 2>/dev/null; \
        rm -f /root/.ssh/known_hosts.bak; \
        chmod 700 /root/.ssh && \
        chmod 600 /root/.ssh/id_ed25519 2>/dev/null && \
        chmod 644 /root/.ssh/id_ed25519.pub 2>/dev/null && \
        chmod 600 /root/.ssh/config 2>/dev/null && \
        echo 'SSH keys ready.'; \
    else \
        echo 'No SSH host mount found, skipping key setup.'; \
    fi && \
    /usr/sbin/sshd -D & \
    echo 'Development container 24 ready!' && \
    echo 'G++ version:'; g++ --version | head -1 && \
    echo 'CMake version:'; cmake --version | head -1 && \
    bash"