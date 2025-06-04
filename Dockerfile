FROM debian:buster-slim

LABEL maintainer="xgh"

ENV XTRABACKUP_VERSION 2.4.29
ENV PS_VERSION 5.7

# 1. 安装基础依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget && \
    rm -rf /var/lib/apt/lists/*

# 2. 手动安装兼容的 libcrypt1
RUN wget http://ftp.debian.org/debian/pool/main/libx/libxcrypt/libcrypt1_4.4.18-4_arm64.deb && \
    dpkg -i libcrypt1_4.4.18-4_arm64.deb && \
    rm libcrypt1_4.4.18-4_arm64.deb

# 3. 安装其他依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libaio1 \
        libnuma1 \
        libtinfo5 \
        libncurses5 \
        libatomic1 \
        libssl1.1 \
        libgcrypt20 \
        procps && \
    rm -rf /var/lib/apt/lists/*

# 4. 设置 OpenSSL 兼容层
RUN mkdir -p /usr/local/openssl/lib && \
    ln -s /usr/lib/aarch64-linux-gnu/libssl.so.1.1 /usr/local/openssl/lib/ && \
    ln -s /usr/lib/aarch64-linux-gnu/libcrypto.so.1.1 /usr/local/openssl/lib/

# 5. 安装 XtraBackup
ADD percona-xtrabackup-${XTRABACKUP_VERSION}-Linux-arm64.glibc2.28.tar.gz /usr/local/
RUN mv /usr/local/percona-xtrabackup-${XTRABACKUP_VERSION}-Linux-arm64.glibc2.28 \
    /usr/local/xtrabackup && \
    ln -sf /usr/local/xtrabackup/bin/* /usr/local/bin/

# 6. 设置环境变量
ENV LD_LIBRARY_PATH=/usr/local/openssl/lib:/usr/lib/aarch64-linux-gnu:$LD_LIBRARY_PATH

# 7. 验证安装
RUN ldd /usr/local/bin/xtrabackup && \
    /usr/local/bin/xtrabackup --version

# 8. 创建运行时用户
RUN groupadd -g 1001 mysql && \
    useradd -u 1001 -r -g mysql -s /sbin/nologin \
        -c "Default Application User" mysql


VOLUME ["/backup"]
CMD ["/usr/local/bin/xtrabackup"]
