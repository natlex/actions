#!/bin/sh

function main() {
  echo $INPUT_PASSWORD > key.json

  gcloud auth activate-service-account $INPUT_USER \
  --key-file=key.json --project=$INPUT_PROJECT

  gcloud compute ssh $INPUT_HOST --project=$INPUT_PROJECT \
  --ssh-flag="-o StrictHostKeyChecking=no" \
  --ssh-flag="-o ExitOnForwardFailure=yes" \
  --ssh-flag="-f" \
  --ssh-flag="-L 127.0.0.1:6789:/var/run/docker.sock" \
  --command="sleep 10"

  docker login -u _json_key -p "$(cat key.json)" \
  https://$INPUT_REGISTRY

  cd ./docker-compose

  DOCKER_HOST="127.0.0.1:6789" docker-compose up -d
}

main
