#!/usr/bin/env bash

# This didn't support symlinked scripts
# COMMON_BASEDIR="$( cd "$( dirname "$0" )" && pwd )"
# Do not use BASEDIR as var name here
COMMON_BASEDIR="$( cd "$( dirname "$(realpath "$0")" )" && pwd )"

export GREEN_COL="\\033[32;1m"
export RED_COL="\\033[1;31m"
export NORMAL_COL="\\033[0;39m"
export GREEN_COL_BACKGROUD="\\033[42;37m"
export NORMAL_COL_BACKGROUD="\\033[0m"

# Common vars
: "${IMAGES_ARCHIVE_FILE:="$(dirname "${COMMON_BASEDIR}")/3rdparty-images.yaml"}"
: "${IMAGES_LIST_FILE:="$(dirname "${COMMON_BASEDIR}")/source-images.list"}"
export IMAGES_ARCHIVE_FILE IMAGES_LIST_FILE
: "${DEVOPS_3RDPARTY_REPO:="harbor.alpha-quant.com.cn:5000/3rd_party"}"
export DEVOPS_3RDPARTY_REPO

# skopeo args
: "${SKOPEO_ARGS_SCOPED:="--scoped"}"
export SKOPEO_ARGS_SCOPED

# Common functions
GET_IMAGE_REGISTRY() {
    fullName=$1
    echo "${fullName%%/*}"
}
GET_IMAGE_REPO() {
    fullName=$1
    fullNameWithoutRegistry=${fullName#*/}
    echo "${fullNameWithoutRegistry%%:*}"
}
GET_IMAGE_TAG() {
    fullName=$1
    echo "${fullName##*:}"
}
export GET_IMAGE_REGISTRY GET_IMAGE_REPO GET_IMAGE_TAG

PRINT_WRAP() {
    echo -e "========================================"
    echo -e "$GREEN_COL_BACKGROUD"
    echo "$1"
    echo -e "$NORMAL_COL_BACKGROUD"
    echo -e "========================================"
}
export PRINT_WRAP
