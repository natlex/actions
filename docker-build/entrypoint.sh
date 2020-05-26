#!/bin/sh

function main() {
  echo "enter in the main location"

  echo ${INPUT_PASSWORD} | docker login --username oauth --password-stdin cr.yandex

  DOCKERNAME="${INPUT_NAME}"
  echo "${DOCKERNAME}"

  docker build -t ${DOCKERNAME} .
  docker tag ${DOCKERNAME} cr.yandex/crptjipt08rs009ssq7m/${DOCKERNAME}
  docker push cr.yandex/crptjipt08rs009ssq7m/${DOCKERNAME}

  docker logout
}

main
