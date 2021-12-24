#!/bin/sh

function main() {
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

  export IMAGE="${INPUT_REGISTRY}/site:${GITHUB_SHA:0:8}"

  cd ./docker-compose
  ssh -o StrictHostKeyChecking=no -i $SSH_PATH/dep_key -f -o ExitOnForwardFailure=yes -L 127.0.0.1:6789:/var/run/docker.sock $INPUT_USER@$INPUT_HOST sleep 10
  docker -H 127.0.0.1:6789 login --username ${INPUT_REGISTRY_USER} --password-stdin ${INPUT_REGISTRY_HOST}
  DOCKER_HOST="127.0.0.1:6789" docker-compose up -d
  docker -H 127.0.0.1:6789 logout ${INPUT_REGISTRY_HOST}
}

main
