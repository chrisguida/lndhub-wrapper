# FROM alpine:latest AS perms

# # This is a bit weird, but required to make sure the LND data can be accessed.
# RUN adduser --disabled-password \
#             --home "/lndhub" \
#             --gecos "" \
#             "lndhub"

FROM node:16-bullseye-slim AS builder

# These packages are required for building LNDHub
RUN apt-get update && apt-get -y install python3

WORKDIR /lndhub

# Copy project files and folders to the current working directory
COPY ./LndHub .

# Install dependencies
RUN npm i
RUN npm run dockerbuild

# Delete git data as it's not needed inside the container
RUN rm -rf .git

FROM node:16-alpine

RUN apk update
RUN apk --no-cache add \
  bash \
  curl \
  redis \
  tini

RUN wget https://github.com/mikefarah/yq/releases/download/v4.25.1/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq

# Create a specific user so LNDHub doesn't run as root
# COPY  --from=perms /etc/group /etc/passwd /etc/shadow  /etc/

# Copy LNDHub with installed modules from builder
COPY  --from=builder /lndhub /lndhub

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD ./check-api.sh /usr/local/bin/check-api.sh
RUN chmod a+x /usr/local/bin/check-api.sh

# Create logs folder and ensure permissions are set correctly
# RUN mkdir -p /lndhub/logs && chown -R lndhub:lndhub /lndhub
# USER lndhub

ENV PORT=3000
EXPOSE 3000
WORKDIR /lndhub

# CMD cp $LND_CERT_FILE /lndhub/ && cp $LND_ADMIN_MACAROON_FILE /lndhub/ && cd /lndhub && npm start
