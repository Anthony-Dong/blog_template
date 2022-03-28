# #######################################################
# Function :Makefile for go                             #
# Platform :All Linux Based Platform                    #
# Version  :1.0                                         #
# Date     :2022-01-26                                  #
# Author   :fanhaodong516@gmail.com                     #
# Usage    :make help		   		                    #
# #######################################################

.PHONY: all push create init build run deploy help

PWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# EXEC_TYPE: docker | local 区别就是设置为docker，全部都运行在docker中! 如果你本地环境OK，那么你直接设置即可！
EXEC_TYPE := ""
EXEC := 
GOOS := $(shell uname | tr A-Z a-z)

ifeq ($(EXEC_TYPE), "docker")
	EXEC := docker run --rm -it -v $(PWD)/hexo-home:/opt/blog -v ${HOME}/.ssh:/root/.ssh -p 4000:4000 hexo
else
	EXEC := cd $(PWD)/hexo-home; sh run.sh
endif

all: help

push: ## push项目到远程
	bin/go-tool markdown --dir $(PWD) --template $(PWD)/.config/README-template.md --ignore /hexo-home --ignore /.config
	git status
	git add .
	git commit -m "提交与 $(shell date +"%Y-%m-%d %H:%M:%S")"
	git push origin master

create: ## 创建博客文件的头部信息
	@echo ""
	@echo "---\ntitle: \ndate: $(shell date +"%Y-%m-%d %H:%M:%S")\ntags:\ncategories:\n---\n"
	@echo ""
	@echo "<!-- more -->"

init: ## 初始化整个项目[第一次执行会比较慢]
	@cd hexo-home; sh build.sh $(EXEC_TYPE)
	@$(EXEC) init
	@if [ ! -e "bin/go-tool" ]; then mkdir -p bin; wget https://github.com/Anthony-Dong/go-tool/releases/download/v1.1.1/go-tool-$(GOOS)-amd64.tgz; tar -zxvf go-tool-$(GOOS)-amd64.tgz ; rm -rf go-tool-$(GOOS)-amd64.tgz;chmod +x bin/go-tool; fi
	@echo "配置Typora的上传文件的命令，可以参考 https://github.com/Anthony-Dong/go-tool/tree/master/command/upload"
	@echo "$(PWD)/bin/go-tool  --log-level fatal upload --file "

build: ## 重新构建网站
	bin/go-tool hexo --dir ./ --target_dir ./hexo-home/source/_posts
	@$(EXEC) build

run: ## 启动网站
	bin/go-tool hexo --dir ./ --target_dir ./hexo-home/source/_posts
	@$(EXEC) run

deploy: ## 发布到个人网站
	@$(EXEC) deploy

help: ## 帮助
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)