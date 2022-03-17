.PHONY: all init build run deploy help

PWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# docker | local 区别就是设置为docker，全部都运行在docker中
EXEC_TYPE := "docker"
EXEC := # 执行命令
GOOS := $(shell uname | tr A-Z a-z)

ifeq ($(EXEC_TYPE), "docker")
	EXEC := docker run --rm -it -v $(PWD)/hexo-home:/opt/blog -v ${HOME}/.ssh:/root/.ssh -p 4000:4000 hexo
else
	EXEC := cd $(PWD)/hexo-home; sh run.sh
endif

all: 
	@echo "$(EXEC)"

create: ## 创建博客文件的头部
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

build: ## 构建
	bin/go-tool hexo --dir ./ --target_dir ./hexo-home/source/_posts
	@$(EXEC) build
run: build ## 启动
	@$(EXEC) run
deploy: ## 发布
	@$(EXEC) deploy
help: ## 帮助
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)