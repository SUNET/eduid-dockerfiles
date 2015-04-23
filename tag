#!/bin/bash

set -e

if [ "x$1" = "x" ]; then
    echo "Syntax: $0 image:tag"
    echo ""
    exit 1
fi

if [ $(id -u) -ne 0 ]; then
    sudo="sudo"
fi

for this in $*; do
    dir=$(echo ${this} | awk -F : '{print $1}')
    test -d ${dir} || echo "Error: ${image} (subdirectory $dir) not found"
    test -d ${dir} || exit 1
done

for this in $*; do
    image=$(echo $this | cut -s -d: -f1 | sed -e 's!/*$!!')    # remove trailing slashes
    tag=$(echo $this | cut -s -d: -f2)
    ${sudo} docker tag -f "eduid/${image}" "docker.sunet.se/eduid/${image}:${tag}"
    echo "Tagged ${tag} set for ${image}."
done
