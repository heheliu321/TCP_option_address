#!/bin/bash
#####################################################################
# toa install
# date:2019-10-08
# Copyright 2008-2013 Support Engineers.
# All rights reserved.
# by shenglifeng
#####################################################################

log_file="/tmp/toa_install.log"

toa_driver_path=/opt/toa-driver
toa_driver_euler="toa.ko"

function log()
{
    [ $# -ne 2 ] && return 0
    case $1 in
		-E|-e)
			echo -e "[ERROR]$(date +%Y-%m-%d\ %H:%M:%S)\t[${FUNCNAME[1]}]:\t\033[1;31m${2}\033[0m" >> "${log_file}"
			echo -e "[ERROR]$(date +%Y-%m-%d\ %H:%M:%S)\t[${FUNCNAME[1]}]:\t\033[1;31m${2}\033[0m"
			;;
		-I|-i)
			echo -e "[INFO]$(date +%Y-%m-%d\ %H:%M:%S)\t[${FUNCNAME[1]}]:\t${2}" >> "${log_file}"
			echo -e "[INFO]$(date +%Y-%m-%d\ %H:%M:%S)\t[${FUNCNAME[1]}]:\t${2}"
			;;
		-D|-d)
			echo -e "[DEBUG]$(date +%Y-%m-%d\ %H:%M:%S)\t[${FUNCNAME[1]}]:\t\033[1;32m${2}\033[0m" >> "${log_file}"
			echo -e "[DEBUG]$(date +%Y-%m-%d\ %H:%M:%S)\t[${FUNCNAME[1]}]:\t\033[1;32m${2}\033[0m"
			;;
    esac
}

function check_env()
{
    log -I "Start to run function check_env()"
	
	#必须是root用户才能安装
    if [ "`whoami`" != "root" ]; then
        log -E "Only super user can  install toa driver"
        return 1
    fi

    is_euler="/etc/euleros-release"
    
    if [ -f "${is_euler}" ]; then
        export install_mode="suse"
    else
        log -E "toa just support eulerOS"
        return 2
    fi
	
	log -I "Start to run function check_env()"
}


function InstallDriver()
{
    if [ -e ${toa_driver_path} ]; then        
        rm -rf ${toa_driver_path}
    fi
    mkdir -p ${toa_driver_path} || exit 5
    cp -rf ${toa_driver_euler} ${toa_driver_path}
    if [ $? -ne 0 ];then
	    log -D "copy toa.ko fail"
        exit 88
	fi

    boot_file="/etc/profile"
    lsmod | grep toa
    if [ $? -eq 0 ];then
	    log -D "reinstall toa.ko"
        driver_toa=`lsmod | grep toa | awk  '{print $1}'`
        rmmod $driver_toa
	fi
	insmod ${toa_driver_path}/${toa_driver_euler}
    if [ ! $? -eq 0 ];then
        log -E "install toa driver fail!"
        exit 104;
    fi

    install_toa="insmod $toa_driver_path/${toa_driver_euler}"
	if ! grep "$install_toa" $boot_file >& /dev/null; then
		echo "$install_toa" >> $boot_file || return 2
	fi

}

function kubectl_support_ipv6() {
    grep "\-\-allowed-unsafe-sysctls=net.ipv6.conf.all.disable_ipv6" /var/paas/kubernetes/kubelet/kubelet || (sed -i 's/\(.*\)"/\1 --allowed-unsafe-sysctls=net.ipv6.conf.all.disable_ipv6"/g' /var/paas/kubernetes/kubelet/kubelet && service kubelet restart)
}

function print_help()
{
	echo "Please input correct param"
	echo "for example:"
	echo "             install toa in euler: ./install.sh"
	echo "             "  
}

if [[ $1 == "--h" ]] || [[ $1 == "--help" ]] ; then
    printHelp
    exit 0
fi

####step1 检查安装环境是否满足要求
check_env
RET_CODE=$?
log -D "check_env:RET_CODE=${RET_CODE}"
[ ${RET_CODE} -ne 0 ] && exit 1

####step2
kubectl_support_ipv6
RET_CODE=$?
log -D "k8s support ipv6:RET_CODE=${RET_CODE}"
[ ${RET_CODE} -ne 0 ] && exit 6
####step3安装驱动
#install start
InstallDriver
RET_CODE=$?
log -D "InstallDriver:RET_CODE=${RET_CODE}"
[ ${RET_CODE} -ne 0 ] && exit 7



