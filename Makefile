
IMAGE=lamp
TAG=latest

build:
	docker build -t $(IMAGE) .

test: build
	docker run --name lamp-test -d -p 8080:80 -p 3307:3306 -v "$$(pwd)"/htdocs:/var/www/localhost/htdocs $(IMAGE)

test-stop:
	-docker stop lamp-test
	-docker container rm lamp-test

test-shell:
	docker exec -it lamp-test sh

push: build
	git add Dockerfile Makefile README.md htdocs/.keep root
	git commit
	git push
	curl -XPOST https://cloud.docker.com/api/build/v1/source/f70a62d9-9ed4-4dbf-9887-64cfa143490c/trigger/e42ddff6-3a61-4d59-abb3-cbd11c34e3cc/call/
