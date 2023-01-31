# #######################################################
# Function :Makefile for go                             #
# Platform :All Linux Based Platform                    #
# Version  :1.0                                         #
# Date     :2021-01-26                                  #
# Author   :fanhaodong516@gmail.com                     #
# Usage    :make		   		                        #
# #######################################################

.PHONY: all push create init build run deploy help

PWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

## EXEC_TYPE: docker | local 区别就是设置为docker，全部都运行在docker中! 如果你本地环境OK，那么你直接设置即可！
EXEC_TYPE := "local"
EXEC :=
GOOS := $(shell uname | tr A-Z a-z)

ifeq ($(EXEC_TYPE), "docker")
	EXEC := docker run --rm -it -v $(PWD)/hexo-home:/opt/blog -v ${HOME}/.ssh:/root/.ssh -p 4000:4000 hexo
else
	EXEC := cd $(PWD)/hexo-home; bash -e run.sh
endif

all: push

push: info ## push项目到远程
	gtool hexo readme --dir $(PWD) --template $(PWD)/.config/README-template.md --ignore /hexo-home --ignore /.config
	git status
	git add .
	git commit -m "提交与 $(shell date +"%Y-%m-%d %H:%M:%S")"
	git push origin master

info: ## 项目信息
	@echo "=====================查看当前目录大小====================================="
	@du -hs ../note**
	@du -hs ./.git
	@du -hs ./bin
	@echo "==================查看大于128k的文件=============================="
	-@find . -size +128k  | grep -v 'hexo-home'
	@echo "===================查看png文件============================="
	-@find . -iname "*.png" | grep -v 'hexo-home'
	@echo "===================查看pdf文件============================="
	-@find . -iname "*.pdf" | grep -v 'hexo-home'

create: ## 创建博客文件的头部信息
	@echo ""
	@echo "---\ntitle: \ndate: $(shell date +"%Y-%m-%d %H:%M:%S")\ntags:\ncategories:\n---\n"
	@echo ""
	@echo "<!-- more -->"

init: init_gtool ## 初始化整个项目[第一次执行会比较慢]
	@cd hexo-home; sh build.sh $(EXEC_TYPE)
	@$(EXEC) init

init_gtool:
	@if [ ! -e "bin/gtool" ]; \
		then mkdir -p bin; \
		gtool_version="v1.0.5"; gtool_file="gtool-linux-amd64.tgz"; \
		if [ $(GOOS) == "darwin" ]; then gtool_file="gtool-darwin-amd64-v12.tgz"; fi ; \
		wget https://github.com/Anthony-Dong/go-sdk/releases/download/$${gtool_version}/$${gtool_file}; tar -zxvf $${gtool_file} ; rm -rf $${gtool_file}; chmod +x bin/gtool; \
	fi
	@echo "配置Typora的上传文件的命令，可以参考 https://github.com/Anthony-Dong/gtool"
	@echo "$(PWD)/bin/gtool  --log-level fatal upload --file "

build: ## 构建
	bin/gtool hexo build --dir ./ --target_dir ./hexo-home/source/_posts
	@$(EXEC) build
run: build ## 启动
	@$(EXEC) run
deploy: build ## 发布
	@$(EXEC) deploy
help: ## 帮助
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)