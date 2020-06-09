FROM ubuntu:20.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app

RUN  apt-get update && apt-get -y install python3 python3-pip

ADD requirements.txt  /tmp/

RUN pip3 install -r /tmp/requirements.txt
