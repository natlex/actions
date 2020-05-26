#!/bin/sh

function main() {
  echo "enter in the main location"

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

  echo "Run.sh go!"

  #ssh -o StrictHostKeyChecking=no -A -tt $INPUT_USER@$INPUT_HOST "$HOME/run.sh $INPUT_IAM"
  ls -a
  scp -r -o StrictHostKeyChecking=no ./ssh-docker-run/service/$INPUT_SERVICE_NAME/ $INPUT_USER@$INPUT_HOST:/home/$INPUT_USER/
  ssh -o StrictHostKeyChecking=no -A -tt $INPUT_USER@$INPUT_HOST "./$INPUT_SERVICE_NAME/run.sh $INPUT_OAUTH $INPUT_REGISTRY"
  #ssh -o StrictHostKeyChecking=no -A -tt $INPUT_USER@$INPUT_HOST "mkdir test-github"

}

main
