FROM node:16 as builder

WORKDIR /app

ADD . .

RUN npm ci --production 

FROM gcr.io/distroless/nodejs:16

WORKDIR /app

COPY --from=builder /app .

ENV PORT=3000

CMD [ "main" ]
