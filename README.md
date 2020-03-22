# TCP Option Address

The TCP Option Address (TOA) module is a kernel module that obtains the source IP address from the option section of a TCP header.

TOA module can be used in the following scenarios:

- obtaining the client IPv4 address from an IPv4 connection
- obtaining the client IPv6 address from an IPv6 connection
- obtaining the client IPv6 address from an NAT64 connection

## How to use the TOA module?

### Requirement

The development environment for compiling the kernel module consists of:

- kernel headers and the module library
- the gcc compiler
- GNU Make tool

### Installation

Download and decompress the source package.

Enter the source code directory and compile the module:

```
cd src
make
```

Load the kernel module:

```
sudo insmod toa.ko
```

测试toa成功启动

```
# lsmod | grep toa
toa                   282624  0
```



### 批量安装

有时候k8s节点比较多，需要批量操作，本文提供两种方式

节点登录密码cnp200@HW123

#### 方式一

```bash
bash -x k8s_bash_install_toa.sh cnp200@HW123
```

#### 方式二

```bash
kubectl -n usg get node | grep -v NAME |awk '{print $1}' | xargs -n 1 -I {} bash -x bash_install.sh {} cnp200@HW123
```

