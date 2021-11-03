
include .env
export

SHELL := /bin/bash

.PHONY: build release

build:
	docker buildx build \
		--build-arg NODE_VERSION=$$NODE_VERSION \
		-f ./Dockerfile \
		--load \
		-t $$IMAGE_NAME:$$IMAGE_VERSION \
		-t $$IMAGE_NAME:latest \
		./hasura-backend-plus

release:
	docker buildx build \
		--build-arg NODE_VERSION=$$NODE_VERSION \
		-f ./Dockerfile \
		--platform linux/amd64,linux/arm64 \
		--push \
		-t $$IMAGE_NAME:$$IMAGE_VERSION \
		-t $$IMAGE_NAME:latest \
		./hasura-backend-plus

