FROM --platform=$BUILDPLATFORM containrrr/watchtower:latest as parent

FROM --platform=$BUILDPLATFORM alpine:3.11 as alpine

RUN apk add --no-cache \
    ca-certificates \
    tzdata

FROM python:3-alpine
LABEL "com.centurylinklabs.watchtower"="true"

COPY --from=alpine \
    /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs/ca-certificates.crt
COPY --from=alpine \
    /usr/share/zoneinfo \
    /usr/share/zoneinfo

EXPOSE 8080

COPY --from=parent \
    /watchtower \
    /watchtower

ENTRYPOINT ["/watchtower"]
