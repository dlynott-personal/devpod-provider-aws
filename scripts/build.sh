#!/usr/bin/env bash

FOLDER=$(dirname "$0")
SCRIPT_F=$(cd "${FOLDER}" && pwd)
PROJ_F="$(dirname "${SCRIPT_F}")"

cd "${PROJ_F}"
go mod tidy

DEFAULT_RELEASE_VERSION='v0.0.0-dev'
if [ -z "${RELEASE_VERSION}" ]; then
    read -p "Please enter RELEASE_VERSION (default: ${DEFAULT_RELEASE_VERSION}): " RELEASE_VERSION
    if [ -z "${RELEASE_VERSION}" ]; then
        RELEASE_VERSION="${DEFAULT_RELEASE_VERSION}"
    fi
fi
export RELEASE_VERSION

./hack/build.sh --dev