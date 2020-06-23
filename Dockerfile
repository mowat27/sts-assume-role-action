FROM alpine:3.11
LABEL maintainer="Adrian Mowat <adrian@flexiclock.com>"

RUN apk --no-cache add jq python py-pip && \
    pip install --upgrade pip awscli

COPY assume_role.sh /usr/local/bin/assume_role.sh

ENTRYPOINT [ "assume_role.sh" ]
