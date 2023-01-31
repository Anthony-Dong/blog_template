#!/bin/sh

set -e

if [ -z "$1" ]; then echo "Usage: $0 [init|build|run|deploy]"; exit 0; fi

init (){
    echo "start init ..."
    npm install
    if [ ! "$(command -v hexo)" ]; then
        echo "command \"hexo\" not exists on system. please exec: npm install hexo-cli@4.3.0 -g"
    fi
    if [ ! "$(command -v gulp)" ]; then
        echo "command \"gulp\" not exists on system. please exec: npm install gulp-cli@2.3.0 -g"
    fi
    echo "hexo --version"
    hexo --version
    echo "gulp --version"
    gulp --version
}

build (){
    echo "start build ..."
    hexo clean
	hexo generate
    gulp  # 压缩html
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

case "$1" in
    "init")
        init
    ;;
    "deploy")
        deploy
    ;;
    "build")
        build
    ;;
    "run")
        run
    ;;
    *)
        echo "not support exec type: ${1}"
        exit 1
    ;;
esac