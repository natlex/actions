FROM docker:19.03.2

RUN apk update && apk add --no-cache openssh py-pip python-dev libffi-dev openssl-dev gcc libc-dev make && \
    pip install docker-compose

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
