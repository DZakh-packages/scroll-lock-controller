FROM node:14.17.0-stretch AS dependencies

ARG devmode=0

RUN if [ "$devmode" = "1" ]; then \
  apt-get update && \
  apt-get install -y nano \
  ; fi

RUN mkdir /opt/app && chown node:node /opt/app
WORKDIR /opt/app

USER node

COPY --chown=node:node package*.json ./
RUN npm ci

FROM dependencies

COPY --chown=node:node . .
