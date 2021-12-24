FROM natlex/opskit:1.0

RUN apk update && apk add --no-cache openssh-client

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
