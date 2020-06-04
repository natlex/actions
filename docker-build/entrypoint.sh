#!/bin/sh

function main() {
  echo "enter in the main location"

  ls -a

  echo ${INPUT_PASSWORD} | docker login --username oauth --password-stdin cr.yandex

  IMAGE_NAME="${INPUT_NAME}"
  echo "${IMAGE_NAME}"
  echo "${GITHUB_SHA}"

  docker pull ${INPUT_REGISTRY}/${IMAGE_NAME}:latest || true

  DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from ${INPUT_REGISTRY}/${IMAGE_NAME}:latest -t ${INPUT_REGISTRY}/${IMAGE_NAME}:${GITHUB_SHA:0:8} .
  docker push ${INPUT_REGISTRY}/${IMAGE_NAME}:${GITHUB_SHA:0:8}

  docker tag ${INPUT_REGISTRY}/${IMAGE_NAME}:${GITHUB_SHA:0:8} ${INPUT_REGISTRY}/${IMAGE_NAME}:latest
  docker push ${INPUT_REGISTRY}/${IMAGE_NAME}:latest

  docker logout cr.yandex
}

main