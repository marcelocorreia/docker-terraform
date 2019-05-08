<!-- Auto generated file, DO NOT EDIT. Please refer to README.yml -->
# docker-terraform

---
![https://img.shields.io/docker/pulls/marcelocorreia/terraform.svg](https://img.shields.io/docker/pulls/marcelocorreia/terraform.svg)
![https://img.shields.io/github/languages/top/marcelocorreia/docker-terraform.svg](https://img.shields.io/github/languages/top/marcelocorreia/docker-terraform.svg)
![https://api.travis-ci.org/marcelocorreia/docker-terraform.svg?branch=master](https://api.travis-ci.org/marcelocorreia/docker-terraform.svg?branch=master)
![https://img.shields.io/github/release/marcelocorreia/docker-terraform.svg?flat-square](https://img.shields.io/github/release/marcelocorreia/docker-terraform.svg?flat-square)
---
### TLDR;
- [Overview](#overview)
- [Description](#description)
- [Dockerfile](#dockerfile)
- [Usage](#usage)
- [Setting Timezone](#setting-timezone)
- [License](#license)
- **Semver versioning**
### Overview
Docker Terraform with some extras


### Description
Docker image with [Hashicorp Terraform](https://www.terraform.io) + [AWS CLI](https://aws.amazon.com/cli/) + Goodies
### Packages
    - ca-certificates
    - update-ca-certificates
    - curl
    - unzip
    - bash
    - python
    - py-pip
    - openssh
    - git
    - make
    - tzdata
    - awscli (via PIP)
    - jq

## INFO
- Workdir is set to /app




### Usage
```bash
$> docker run --rm -v $(pwd):/app \
   		marcelocorreia/terraform \
   		terraform [--version] [--help] <command> [args]
```

## Setting timezone
```bash
$> docker run --rm -v $(pwd):/app \
        -e TZ=Australia/Sydney \
   		marcelocorreia/terraform \
   		terraform [--version] [--help] <command> [args]
```


## Example
```bash
$> docker run --rm -v $(pwd):/app \
   		marcelocorreia/terraform \
   		terraform plan -var-file variables.tfvars \
   		-var aws_access_key=${aws_access_key_id} \
   		-var aws_secret_key=${aws_secret_access_key}
```




## Dockerfile 
```Dockerfile
FROM hashicorp/terraform

MAINTAINER marcelo correia <marcelo@correia.io>

ARG terraform_version="0.11.3"

RUN apk update

RUN set -ex && \
	apk add ca-certificates && update-ca-certificates && \
	apk add --no-cache --update \
        curl \
        unzip \
        bash \
        make \
        tree \
        tzdata \
        python \
        py-pip \
        python-dev \
        libffi-dev \
        build-base && \
    pip install --upgrade pip && \
    pip install awscli

RUN mkdir -p /app

RUN rm /var/cache/apk/*

WORKDIR /app

ENTRYPOINT ["terraform"]

```


### License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright [2015]

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


---
[:hammer:**Created with a Hammer**:hammer:](https://github.com/marcelocorreia/hammer)
<!-- -->
















