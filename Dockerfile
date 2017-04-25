FROM alpine:3.5
MAINTAINER marcelo correia <marcelocorreia@starvisitor.com>

RUN apk update
RUN apk add --no-cache curl unzip bash python py-pip
RUN pip install awscli
RUN curl https://releases.hashicorp.com/terraform/0.9.3/terraform_0.9.3_linux_amd64.zip -o terraform_0.9.3_linux_amd64.zip
RUN unzip terraform_0.9.3_linux_amd64.zip -d /usr/local/bin
RUN mkdir -p /opt/workspace
RUN rm /var/cache/apk/*
WORKDIR /opt/workspace

CMD terraform version