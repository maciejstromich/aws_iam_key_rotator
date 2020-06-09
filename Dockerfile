FROM alpine:3.12

MAINTAINER <maciej.stromich>

RUN mkdir /app
WORKDIR /app

RUN  apk add --no-cache python3 py3-pip

ADD requirements.txt  /tmp/

RUN pip3 install -r /tmp/requirements.txt
