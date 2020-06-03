FROM tiangolo/docker-with-compose:latest

RUN apk update && apk add --no-cache openssh

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
