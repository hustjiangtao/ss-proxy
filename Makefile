# build and push docker image to github container registry
# Usage: make login build push
# Note: replace `your-github-username` and `your-repo-name` with your github username and repository name
# Note: replace `GITHUB_TOKEN` with your github token

YOUR_GITHUB_USERNAME=hustjiangtao
YOUR_REPO_NAME=ss-proxy

# login to github container registry
login:
	echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${YOUR_GITHUB_USERNAME} --password-stdin

# build docker image
build:
	docker build -t ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest .

# push docker image to github container registry
push:
	docker push ghcr.io/${YOUR_GITHUB_USERNAME}/${YOUR_REPO_NAME}:latest