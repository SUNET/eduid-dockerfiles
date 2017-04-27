#!/bin/bash
#
# Tag the locally built 'latest' with a new tag.
#

set -e

. ./common.sh

if [ "x$1" = "x" ]; then
    echo "Syntax: $0 image:tag ..."
    echo ""
    exit 1
fi

sudo=$(get_docker_sudo_command)

check_is_subdirs $*

for this in $*; do
    local_base=$(get_local_image_base)
    base=$(get_repository_image_base)
    image=$(echo $this | cut -s -d: -f1 | sed -e 's!/*$!!')    # remove trailing slashes
    tag=$(echo $this | cut -s -d: -f2)

    docker tag "${local_base}/${image}" "${base}/${image}:${tag}"
    echo "Tagged ${base}/${image}:${tag} from ${local_base}/${image}"
    docker images "${base}/${image}:${tag}"
done
