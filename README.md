# TCP Option Address

The TCP Option Address (TOA) module is a kernel module that obtains the source IPv4 address from the option section of a TCP header.

## How to use the TOA module?

### Requirement

The development environment for compiling the kernel module consists of: 
- kernel headers and the module library
- the gcc compiler
- GNU Make tool

### Installation

Download and decompress the source package:
```
https://github.com/Huawei/TCP_option_address/archive/master.zip
```

Enter the source code directory and compile the module:
```
cd src
make
```

Load the kernel module:
```
sudo insmod toa.ko
```

### 采坑汇总：

1）虚拟机没有下载欧拉操作系统源码

![img](file:///C:/Users/n00444323/AppData/Roaming/eSpace_Desktop/UserData/n00444323/imagefiles/CC69B66F-9EC1-491E-8967-CBA44FD32CF3.png)

yum install kernel-devel下载解决，后来遇到另一个问题，重启操作解决，

![1584432436447](C:\Users\N00444~1\AppData\Local\Temp\1584432436447.png)
