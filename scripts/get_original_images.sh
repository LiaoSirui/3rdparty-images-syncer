#!/usr/bin/env bash

set -eo pipefail

# This didn't support symlinked scripts
# BASEDIR="$( cd "$( dirname "$0" )" && pwd )"
BASEDIR="$( cd "$( dirname "$(realpath "$0")" )" && pwd )"

# shellcheck source=./common.sh
source "${BASEDIR}/common.sh"

all_images=$(yq eval "
    .[][][]
    | [
        (. | path | .[-3]) + \"/\" + (. | path |.[-2]) + \":\" + .
    ]
" "${IMAGES_ARCHIVE_FILE}")

PRINT_WRAP "${all_images}"
