#!/bin/bash

function faketty() {
    script -qefc "$(printf "%q " "$@")" /dev/null
}

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
    if [[ "${2:-}" == "all" ]]
    then
        ./build.sh -x do_ctest_all -t debug
    elif [[ "${2:-}" == "verify" ]]
    then
        ./build.sh -x do_verify_host -t debug
    else
        # Interactive select of UnitTest :)
        source scripts/utils.sh
        tests=$(cd .build-kirkstone-x86/debug && ctest -N | grep '#')
        selected=$(echo "$tests" | wofi --dmenu --cache-file /dev/null | awk -F '#|:' '{print $2}')
        [ -z ${selected:-} ] && echo "No test selected, stopping..." && exit 0
        faketty ./build.sh -x do_ctest_select -t debug <<< $(echo $selected)
    fi
elif [[ "$1" == "deploy" ]]
then
    device="$(cat devices.json | jq -r '.groups | with_entries(.value |= .[])' | wofi --dmenu -i --cache /dev/null | cut -d ':' -f 1 | xargs)"
    [ -z ${device:-} ] && echo "Please select a device..." && exit 0
    cat devices.json > devices.json.bak
    if [[ "$device" == "ip-address" ]]
    then
        read -e -p "Enter ip-address: " chosen_ip
        newDevices=$(cat devices.json | jq '.groups[".ip-address"]=["'$chosen_ip'"] | .defaultGroup=".ip-address"')
    else
        newDevices=$(cat devices.json | jq '.defaultGroup="'$device'"')
    fi
    echo -n "$newDevices" > devices.json
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

