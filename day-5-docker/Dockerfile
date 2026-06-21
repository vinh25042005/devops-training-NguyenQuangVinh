## BUILD ##
FROM node:20 AS build

WORKDIR /build
COPY app/ ./

## RUN ##
FROM node:20-alpine

LABEL org.opencontainers.image.title="demo"
LABEL org.opencontainers.image.version="1.0.0"

RUN adduser -D server-user

WORKDIR /app
COPY --from=build /build/ ./

RUN chown -R server-user:server-user /app

USER server-user

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:3000 || exit 1

CMD ["node", "server.js"]