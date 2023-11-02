#!/usr/bin/env bash

set -eo pipefail

# This didn't support symlinked scripts
# BASEDIR="$( cd "$( dirname "$0" )" && pwd )"
BASEDIR="$( cd "$( dirname "$(realpath "$0")" )" && pwd )"

# shellcheck source=./common.sh
source "${BASEDIR}/common.sh"

export SKOPEO_SYNC_COMMAND=(
    "skopeo" "sync"
    "--insecure-policy"
    "--src-tls-verify=false" "--dest-tls-verify=false"
    "--dest-authfile=/root/.docker/config.json"
    "--retry-times=10"
    "--all"
    "${SKOPEO_ARGS_SCOPED}"
    "--src" "docker" "--dest" "docker"
)

export SKEPEO_INSPECT_COMMAND=(
    "skopeo" "inspect"
    "--tls-verify=false"
)

skopeo_sync() {
    imageFullName=${1:="rockylinux:9.0.20220720"}
    imageInspectName=$("${SKEPEO_INSPECT_COMMAND[@]}" -f '{{.Name}}' "docker://${imageFullName}")
    imageFullName=${imageInspectName}:$(GET_IMAGE_TAG ${imageFullName})
    # :port to _port
    imageDestName="${DEVOPS_3RDPARTY_REPO}/${imageFullName}"
    echo -e "$GREEN_COL Progress: ${CURRENT_NUM}/${TOTAL_NUMS} sync ${imageFullName} to ${imageDestName} start $NORMAL_COL"
    echo -e "$GREEN_COL Exec: " "${SKOPEO_SYNC_COMMAND[@]}" "${imageFullName}" "${DEVOPS_3RDPARTY_REPO}" "$NORMAL_COL"
    if "${SKOPEO_SYNC_COMMAND[@]}" "${imageFullName}" "${DEVOPS_3RDPARTY_REPO}"; then
        echo -e "$GREEN_COL Progress: ${CURRENT_NUM}/${TOTAL_NUMS} sync ${imageFullName} to ${imageDestName} successful $NORMAL_COL"
    else
        echo -e "$RED_COL Progress: ${CURRENT_NUM}/${TOTAL_NUMS} sync ${imageFullName} to ${imageDestName} failed $NORMAL_COL"
        exit 2
    fi

    # yq -> update ${IMAGES_ARCHIVE_FILE}
    imageRegistry=$(GET_IMAGE_REGISTRY "${imageFullName}")
    imageRepo=$(GET_IMAGE_REPO "${imageFullName}")
    imageTag=$(GET_IMAGE_TAG "${imageFullName}")
    yq -i "
        .\"${imageRegistry}\".\"${imageRepo}\" = (
            .\"${imageRegistry}\".\"${imageRepo}\" + [\"${imageTag}\"]
            | unique
        )" "${IMAGES_ARCHIVE_FILE}"
}

CURRENT_NUM=0
ALL_IMAGES=$(sed -n '/#/d;s/:/:/p' "${IMAGES_LIST_FILE}" | sort -u)
TOTAL_NUMS=$(wc -l < "${IMAGES_LIST_FILE}" )

for image in ${ALL_IMAGES}; do
    (( CURRENT_NUM="${CURRENT_NUM}"+1 ))
    skopeo_sync "${image}"
done

# clean source-images.list
true > "${IMAGES_LIST_FILE}"
