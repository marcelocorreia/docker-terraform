FROM alpine:3.5
MAINTAINER marcelo correia <marcelocorreia@starvisitor.com>

RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
RUN apk add --no-cache --update curl unzip bash python py-pip
RUN apk add --update tzdata
RUN pip install --upgrade pip
RUN pip install awscli
RUN curl https://releases.hashicorp.com/terraform/0.9.4/terraform_0.9.4_linux_amd64.zip -o terraform_0.9.4_linux_amd64.zip
RUN unzip terraform_0.9.4_linux_amd64.zip -d /usr/local/bin

RUN cp /usr/share/zoneinfo/Australia/Sydney /etc/localtime
RUN echo "Australia/Sydney" >  /etc/timezone

RUN mkdir -p /opt/workspace
RUN rm /var/cache/apk/*

ENV TZ="Australia/Sydney"

WORKDIR /opt/workspace

CMD terraform version