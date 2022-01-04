# FROM crystallang/crystal:latest-alpine AS build
# COPY . /project
# WORKDIR /project
# RUN shards build --progress --static
FROM ubuntu
ENV LC_ALL=en_US.UTF-8  TZ=America/New-York DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime &&\
    apt-get update &&\
    apt-get upgrade -yq gcc pkg-config git tzdata \
                        libpcre3-dev libevent-dev libyaml-dev \
                        libgmp-dev libssl-dev libxml2-dev\
                        libmagic1 libmagic-dev
# ENV config_file=/etc/order-form.yml
RUN mkdir /project
COPY shard.yml /project/shard.yml
COPY shard.lock /project/shard.lock
COPY src/ /project/src/
COPY lib/ /project/lib/
WORKDIR /project
COPY bin/shards /bin/shards
COPY bin/crystal /bin/crystal
RUN shards build --release --production && mv bin/order-form /bin/order-form
ENTRYPOINT [ "order-form" ]
