#!/usr/bin/env bash

FOLDER=$(dirname "$0")
SCRIPT_F=$(cd "${FOLDER}" && pwd)
PROJ_F="$(dirname "${SCRIPT_F}")"

cd "${PROJ_F}"

echo "[INFO] PROJ_F: ${PROJ_F}"

if [ -n "${HOST_WORKSPACE}" ]; then
    echo "[ERROR] You're running within a devcontainer and DevPod is installed on host. Aborting!"
    exit 1
fi

PROVIDER_ID=${PROVIDER_ID:-aws-collins-sae}
echo "[INFO] Removing existing provider name: ${PROVIDER_ID}"
devpod provider delete "${PROVIDER_ID}" > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "[WARN] failed to remove provider: ${PROVIDER_ID}"
    echo "[WARN] provider (${PROVIDER_ID}) may have already been removed"
fi

while [ -z "${AWS_PROFILE}" ]; do
    read -p "Please enter AWS_PROFILE: " AWS_PROFILE
done
while [ -z "${AWS_REGION}" ]; do
    read -p "Please enter AWS_REGION: " AWS_REGION
done

echo "[INFO] Installing locally built provider against SAE AVI Commercial Dev CACE environment"
devpod provider add ./release/provider.yaml \
    --name "${PROVIDER_ID}" --debug \
    -o AWS_PROFILE="${AWS_PROFILE}" \
    -o AWS_REGION="${AWS_REGION}" \
    -o AWS_AMI=ami-073452aab5109d24e \
    -o AWS_INSTANCE_TYPE=t2.large \
    -o AWS_SUBNET_ID=subnet-0569d0f531581c0d9 \
    -o AWS_VPC_ID=vpc-0de2ba291d3dcd721 \
    -o AWS_DISK_SIZE=30 \
    -o AWS_ROOT_DEVICE=/dev/sda1 \
    -o PROXY=http://proxy.rockwellcollins.com:9090 \
    -o NON_PROXIED_HOSTS=localhost,127.0.0.1,169.254.169.254

read -p "Configure with a custom AMI UserData? [y/N]"
REPLY=${REPLY:-n}
if [ "${REPLY}" == 'y' ]; then
    read -p "Enter FULL path to script to append to AMI UserData: "
    if [ -n "${REPLY}" ]; then
        devpod provider update "${PROVIDER_ID}" --debug -o USER_DATA_SCRIPT="${REPLY}"
    fi
fi
echo "[INFO] Settings for your provider: ${PROVIDER_ID}"
devpod provider options
