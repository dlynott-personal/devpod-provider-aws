#!/usr/bin/env bash

FOLDER=$(dirname "$0")
SCRIPT_F=$(cd "${FOLDER}" && pwd)
PROJ_F="$(dirname $(dirname "${SCRIPT_F}"))"

cd "${PROJ_F}"

echo "[INFO] PROJ_F: ${PROJ_F}"

echo "[ERROR] This script is not implemented yet"
