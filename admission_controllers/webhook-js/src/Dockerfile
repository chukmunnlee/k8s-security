ARG NODE_VER=17

FROM node:${NODE_VER}

ARG APP_DIR=/app

ENV PORT=8443

WORKDIR ${APP_DIR}

ADD package.json .
ADD package-lock.json .

RUN npm ci

ADD main.js .


EXPOSE ${PORT}

ENTRYPOINT [ "node", "main.js" ]

