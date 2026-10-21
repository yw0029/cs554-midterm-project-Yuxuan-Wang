FROM node:22.23.3-bookworm-slim

WORKDIR /app

COPY --chown=node:node package.json ./
COPY --chown=node:node src/ ./src/

USER node

EXPOSE 8080

CMD ["node", "src/server.js"]
