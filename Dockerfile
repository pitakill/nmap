FROM gliderlabs/alpine:latest

RUN apk add --no-cache nmap
COPY entrypoint.sh /entrypoint.sh
WORKDIR /workdir

ENTRYPOINT ["/entrypoint.sh"]
