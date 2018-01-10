FROM alpine:latest

MAINTAINER <ce@castlabs.com>

RUN mkdir /app
WORKDIR /app

RUN  apk add --no-cache python3

ADD requirements.txt  .

RUN pip3 install -r requirements.txt
