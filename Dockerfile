FROM alpine:3.6
MAINTAINER marcelo correia <marcelocorreia@starvisitor.com>
ARG tf_version="0.10.7"
RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
RUN apk add --no-cache --update \
    curl \
    unzip \
    bash \
    python \
    py-pip \
    git \
    openssh \
    make \
    libffi-dev \
    jq
RUN apk add dos2unix --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
RUN apk add --update tzdata
RUN pip install --upgrade pip
RUN pip install awscli
RUN curl https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip -o terraform_${tf_version}_linux_amd64.zip
RUN unzip terraform_${tf_version}_linux_amd64.zip -d /usr/local/bin
RUN mkdir -p /opt/workspace
RUN rm /var/cache/apk/*

WORKDIR /opt/workspace
CMD terraform version
