ARG NODE_VERSION

FROM node:${NODE_VERSION} AS builder

WORKDIR /app

COPY . .
COPY package.json yarn.lock ./

ENV npm_config_sharp_binary_host="https://npm.taobao.org/mirrors/sharp"
ENV npm_config_sharp_libvips_binary_host="https://npm.taobao.org/mirrors/sharp-libvips"

RUN yarn install
RUN yarn build

ARG NODE_VERSION

FROM node:${NODE_VERSION}

WORKDIR /app

ARG NODE_ENV=production

ENV NODE_ENV $NODE_ENV
ENV PGOPTIONS "-c search_path=auth"
ENV PORT 3000

COPY --from=builder /app/dist dist
COPY --from=builder /app/node_modules node_modules
COPY custom custom
COPY migrations migrations
COPY package.json .
COPY prod-paths.js .

HEALTHCHECK --interval=60s --timeout=2s --retries=3 CMD wget localhost:${PORT}/healthz -q -O - > /dev/null 2>&1

EXPOSE $PORT

CMD ["node", "-r", "./dist/start.js"]
