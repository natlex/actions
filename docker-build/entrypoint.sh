#!/bin/sh

function main() {
  echo "enter in the main location"

  echo ${INPUT_PASSWORD} | docker login --username oauth --password-stdin cr.yandex

  DOCKERNAME="${INPUT_NAME}"
  echo "${DOCKERNAME}"

  docker build -t ${DOCKERNAME} .
  docker tag ${DOCKERNAME} ${INPUT_REGISTRY}/${DOCKERNAME}
  docker push ${INPUT_REGISTRY}/${DOCKERNAME}

  docker logout
}

main
