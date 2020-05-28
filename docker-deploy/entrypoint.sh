#!/bin/sh

function main() {
  echo "enter in the main location"
  docker-compose -v

  set -e
  SSH_PATH="$HOME/.ssh"
  mkdir -p "$SSH_PATH"
  touch "$SSH_PATH/known_hosts"

  echo "$INPUT_DEP_KEY" > "$SSH_PATH/dep_key"

  chmod 700 "$SSH_PATH"
  chmod 600 "$SSH_PATH/known_hosts"
  chmod 600 "$SSH_PATH/dep_key"

  eval $(ssh-agent)
  ssh-add "$SSH_PATH/dep_key"
  ssh-keyscan -t rsa $INPUT_HOST >> "$SSH_PATH/known_hosts"

  ssh -o StrictHostKeyChecking=no -i $SSH_PATH/dep_key -f -o ExitOnForwardFailure=yes -L 127.0.0.1:6789:/var/run/docker.sock $INPUT_USER@$INPUT_HOST sleep 10
  echo ${INPUT_PASSWORD} | docker -H 127.0.0.1:6789 login --username oauth --password-stdin cr.yandex

  export IMAGE="${INPUT_REGISTRY}/site:${GITHUB_SHA:0:8}"
  echo "$IMAGE"
  cd ./docker-compose
  DOCKER_HOST="127.0.0.1:6789" docker-compose up

  docker logout cr.yandex
}

main
