#!/bin/bash
password=cnp200@HW123
remote_ecs_ip=${1}
remote_db_ip=${db_ip}
remote_path=/opt

#如果不存在，则安装expect工具
if [ ! -f "/usr/bin/expect" ];then
tar -xfvz tools/tcl8.4.11-src.tar.gz
cd tcl8.4.11/unix
./configure --prefix=/usr/tcl --enable-shared
make
make install
cp tclUnixPort.h ../generic/
cd ${currentPath}/tools

tar -xzvf tools/expect5.45.tar.gz
cd expect5.45
./configure --prefix=/usr/expect --with-tcl=/usr/tcl/lib --with-tclinclude=../tcl8.4.11/generic
make
make install
ln -s /usr/tcl/bin/expect /usr/expect/bin/expect
cp /usr/expect/bin/expect /usr/bin/
fi

# 拷贝toa安装包
/usr/bin/expect <<EOF
set timeout 1800
spawn scp -r toa_package/ root@${remote_ecs_ip}:${remote_path};
expect {
"The authenticity of host*" { send "yes\r";exp_continue}
"*assword*" { send "$password\n"}
}
expect eof
EOF

# 远程执行安装
/usr/bin/expect <<EOF
set timeout 1800
spawn ssh root@${remote_ecs_ip} "cd ${remote_path}/toa_package;bash -x install.sh;echo result_\$?;"
expect {
"The authenticity of host*" { send "yes\r";exp_continue}
"*assword*" { send "$password\n"}
}
expect eof
EOF
exit 0
