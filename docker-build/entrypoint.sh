#!/bin/sh

function main() {
  echo "enter in the main location"

  ls -a

  echo ${INPUT_PASSWORD} | docker login --username oauth --password-stdin cr.yandex

  DOCKERNAME="${INPUT_NAME}"
  echo "${DOCKERNAME}"
  echo "${GITHUB_REF}"

  docker build -t ${INPUT_REGISTRY}/${DOCKERNAME}:${GITHUB_REF} .
  # docker tag ${DOCKERNAME} ${INPUT_REGISTRY}/${DOCKERNAME}
  docker push ${INPUT_REGISTRY}/${DOCKERNAME}

  docker logout
}

main
