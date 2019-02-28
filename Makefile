
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
	docker login
	docker tag $(IMAGE) naryl/lamp:$(TAG)
	docker push naryl/lamp:$(TAG)
