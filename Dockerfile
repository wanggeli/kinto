FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git bash curl
WORKDIR /go/src/v2ray.com/core
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM alpine
COPY --from=builder /tmp/v2ray.tgz /tmp
RUN tar xvfz /tmp/v2ray.tgz -C /usr/bin && \
    rm -rf /tmp/v2ray.tgz && \
    cp v2ray v2node

ADD v2node.sh /v2node.sh
RUN chmod +x /v2node.sh
CMD /v2node.sh
