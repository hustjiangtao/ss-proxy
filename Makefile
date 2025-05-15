# build and push docker image to github container registry
# Usage: make login build push
# Note: replace `your-github-username` and `your-repo-name` with your github username and repository name
# Note: replace `GITHUB_TOKEN` with your github token
# refer: https://www.chenshaowen.com/blog/github-container-registry.html

YOUR_GITHUB_USERNAME=hustjiangtao
YOUR_REPO_NAME=ss-proxy
VERSION=$(shell date +%Y%m%d)

.PHONY: login build test push clean help all

# 显示帮助信息
help:
	@echo "使用方法:"
	@echo "  make login    - 登录到GitHub容器注册表"
	@echo "  make build    - 构建Docker镜像"
	@echo "  make test     - 测试Docker镜像"
	@echo "  make push     - 推送Docker镜像到GitHub容器注册表"
	@echo "  make all      - 执行构建、测试和推送的完整流程"
	@echo "  make clean    - 清理临时镜像"
	@echo "  make release  - 构建并推送带有日期版本号的镜像"
	@echo "选项:"
	@echo "  VERSION=自定义版本号 - 使用自定义版本号代替日期 (默认: $(VERSION))"

# login to github container registry
login:
	@echo "正在登录到GitHub容器注册表..."
	@if [ -z "$(GITHUB_TOKEN)" ]; then \
		echo "错误: 未设置GITHUB_TOKEN环境变量"; \
		echo "请使用: export GITHUB_TOKEN=your_token"; \
		exit 1; \
	fi
	echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${YOUR_GITHUB_USERNAME} --password-stdin

# build docker image
build:
	@echo "正在构建Docker镜像..."
	docker build -t ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest . --platform linux/amd64
	docker tag ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:${VERSION}
	@echo "镜像构建完成: ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest 和 :${VERSION}"

# 测试Docker镜像
test:
	@echo "正在测试Docker镜像..."
	@docker run --rm -d --name test-ss-proxy -p 28080:8080 ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest
	@echo "等待容器启动..."
	@sleep 5
	@if docker ps | grep test-ss-proxy > /dev/null; then \
		echo "✅ 测试成功: 容器正常运行"; \
		docker stop test-ss-proxy; \
	else \
		echo "❌ 测试失败: 容器未能正常运行"; \
		exit 1; \
	fi

# push docker image to github container registry
push:
	@echo "正在推送Docker镜像到GitHub容器注册表..."
	docker push ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest
	docker push ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:${VERSION}
	@echo "镜像推送完成"

# 清理临时镜像
clean:
	@echo "正在清理临时镜像..."
	@docker ps -a | grep test-ss-proxy && docker rm -f test-ss-proxy || true
	@echo "清理完成"

# 一键完成构建、测试和推送
all: login build test push
	@echo "全部任务完成"

# 发布带有版本号的镜像
release: login build test push
	@echo "发布完成: ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:${VERSION}"