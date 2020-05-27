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

  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $SSH_PATH/dep_key -f -o ExitOnForwardFailure=yes -L 127.0.0.1:6789:/var/run/docker.sock $INPUT_USER@$INPUT_HOST sleep 10

  echo ${INPUT_PASSWORD} | docker -H 127.0.0.1:6789 login --username oauth --password-stdin cr.yandex

  cd ./docker-compose
  sudo docker-compose up -d traefik
  sudo docker-compose up -d site

  # chmod 777 ./docker-compose/run.sh
  # cat "$SSH_PATH/dep_key"
  # cat "$SSH_PATH/known_hosts"
  # ls -a ./docker-compose
  # echo "$INPUT_USER@$INPUT_HOST"
  # ssh -o StrictHostKeyChecking=no -A -tt $INPUT_USER@$INPUT_HOST "docker-compose -v"
  # scp -r -o StrictHostKeyChecking=no ./docker-compose/ $INPUT_USER@$INPUT_HOST:/home/$INPUT_USER/
  # echo "test"
  # ssh -o StrictHostKeyChecking=no -A -tt $INPUT_USER@$INPUT_HOST "sudo ./docker-compose/run.sh $INPUT_PASSWORD $INPUT_REGISTRY"
}

main
