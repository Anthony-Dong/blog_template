#!/bin/sh

if [ -z "$1" ]; then echo "Usage: $0 [docker|local]";exit 0; fi

action="$1"

build_docker(){
    docker build -t hexo .
}

if [ "$action" = "docker" ]; then echo "build docker"; build_docker || exit 1; fi

