#!/bin/sh
if [ -z "$1" ]; then echo "Usage: $0 [init|build|run|deploy]"; exit 0; fi
action="$1"
init (){
    echo "start init ..."
    npm install
}

build (){
    echo "start build ..."
    hexo clean
	hexo generate
}

deploy (){
    build
    echo "start deploy ..."
    hexo deploy
}

run (){
    echo "start run ...."
    hexo server --debug
}

if [ "$action" = "init" ]; then init || exit 1 && exit 0; fi
if [ "$action" = "deploy" ]; then deploy || exit 1 && exit 0; fi
if [ "$action" = "build" ]; then build || exit 1 && exit 0; fi
if [ "$action" = "run" ]; then run || exit 1 && exit 0; fi
