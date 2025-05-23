# Percona XtraBackup 2.4.29 ARM64 (麒麟V10 环境) 编译与安装指南

## 环境要求

- **操作系统**：ARM架构的麒麟V10
- **libc 版本**：2.28
- **make 版本**：4.3

## 源码包下载

[Percona XtraBackup 2.4.29 源码包](https://downloads.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.29/source/tarball/percona-xtrabackup-2.4.29.tar.gz)

## 依赖安装

```bash
yum install -y curl-devel libgcrypt-devel crypt* libev-devel
```

> **注意：**
> 编译时需要 Boost 1.59.0。如果无法访问外网，请提前下载：
>
> ```bash
> wget https://nchc.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
> ```

## 编译步骤

1. 创建安装目录并进入：

    ```bash
    mkdir -p /home/apps/percona-xtrabackup
    cd /home/apps/percona-xtrabackup
    ```

2. 下载源码包和依赖：

    ```bash
    wget https://downloads.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.29/source/tarball/percona-xtrabackup-2.4.29.tar.gz
    yum install -y curl-devel libgcrypt-devel crypt* libev-devel
    wget https://nchc.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
    ```

3. 解压源码包：

    ```bash
    tar xzvf percona-xtrabackup-2.4.29.tar.gz
    cd percona-xtrabackup-2.4.29
    ```

4. 创建构建目录并进入：

    ```bash
    mkdir build
    cd build
    ```

5. 配置编译参数（请将 `/home/apps/percona-xtrabackup/boost_1_59_0.tar.gz` 替换为实际 Boost 路径）：

    ```bash
    cmake .. \
      -DWITH_BOOST=/path/to/boost \
      -DDOWNLOAD_BOOST=OFF \
      -DWITH_BOOST=/home/apps/percona-xtrabackup/boost_1_59_0.tar.gz \
      -DBUILD_CONFIG=xtrabackup_release
    ```

6. 开始编译：

    ```bash
    make -j$(nproc)
    ```

## 安装

```bash
make install
```

## 验证安装

```bash
/usr/local/xtrabackup/bin/innobackupex --version
```

---

> 如有问题请在 Issues 区提交反馈。