FROM alpine:3.5
MAINTAINER marcelo correia <marcelocorreia@starvisitor.com>

RUN apk update
RUN apk add --no-cache wget unzip
RUN wget --no-check-certificate https://releases.hashicorp.com/terraform/0.9.2/terraform_0.9.2_linux_amd64.zip
RUN unzip terraform_0.9.2_linux_amd64.zip -d /usr/local/bin
CMD terraform version
