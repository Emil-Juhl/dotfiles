#!/bin/bash

function ip_from_hostname() {
    local hst="$1"
    local ip=""

}

if [ -z "$1" ]
then
    cat << EOF
Usage:
    - build : build release with debug info
    - deploy : do-deploy release with debug info
    - shell : launch docker shell
EOF
    exit 1
fi

if [[ "$1" == "build" ]]
then
    ./build.sh -i all -t relwithdebinfo
elif [[ "$1" == "buildx86" ]]
then
    ./build.sh -x all -t debug
elif [[ "$1" == "test" ]]
then
    if [[ "$2" == "all" ]]
    then
        ./build.sh -x do_ctest_all -t debug
    fi
elif [[ "$1" == "deploy" ]]
then
    ./build.sh -i do_deploy -t relwithdebinfo -n
elif [[ "$1" == "shell" ]]
then
    ./scripts/docker_shell.sh
elif [[ "$1" == "dump" ]]
then
    WKDIR="/home/emdj/mozart"
    GDB="sdk/imx8m/sysroots/x86_64-mozartsdk-linux/usr/bin/aarch64-mozart-linux/aarch64-mozart-linux-gdb"
    #PROG=".build-hardknott-imx8m/coredump/program"
    PROG=".build-hardknott-imx8m/relwithdebinfo/.install/usr/bin/mozart-application"
    DMP=".build-hardknott-imx8m/coredump/core"
    SYMBOLS=".build-hardknott-imx8m/relwithdebinfo/.install/usr/*"
    SYSROOT="sdk/imx8m/sysroots/cortexa53-crypto-mozart-linux"

    "${WKDIR}/${GDB} --eval-command='set solib-search-path ${WKDIR}/${SYMBOLS}' --eval-command='set sysroot ${WKDIR}/${SYSROOT}' --core='${WKDIR}/${DMP}' ${WKDIR}/${PROG}"
fi

