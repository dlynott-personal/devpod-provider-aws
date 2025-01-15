#!/usr/bin/env bash

FOLDER=$(dirname "$0")
SCRIPT_F=$(cd "${FOLDER}" && pwd)
PROJ_F="$(dirname $(dirname "${SCRIPT_F}"))"

cd "${PROJ_F}"

echo "[INFO] PROJ_F: ${PROJ_F}"

if [ "$(whoami)" == "collins" ]; then
    echo "[ERROR] You're running within a devcontainer and DevPod is installed on host. Aborting!"
    exit 1
fi

devpod provider delete aws-customized > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "[INFO] failed to delete provider: aws-customized"
fi
devpod provider add ./release/provider.yaml \
    --name aws-customized --debug \
    -o AWS_PROFILE=avi.dev \
    -o AWS_REGION=us-east-2 \
    -o PROXY=http://proxy.rockwellcollins.com:9092 \
    -o NON_PROXIED_HOSTS=localhost,127.0.0.1,169.254.169.254 \
    -o AWS_AMI=ami-073452aab5109d24e \
    -o AWS_INSTANCE_TYPE=t2.large \
    -o AWS_SUBNET_ID=subnet-0569d0f531581c0d9 \
    -o AWS_VPC_ID=vpc-0de2ba291d3dcd721 \
    -o AWS_DISK_SIZE=30 \
    -o AWS_ROOT_DEVICE=/dev/sda1