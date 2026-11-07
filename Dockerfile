FROM node:22-alpine

RUN corepack enable && corepack prepare pnpm@11.9.0 --activate

RUN addgroup -S firefli && adduser -S firefli -G firefli

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./
COPY prisma ./prisma/

# Configure pnpm to allow all necessary build scripts via .npmrc
RUN echo "only-built-dependencies=[\"@parcel/watcher\",\"@prisma/engines\",\"core-js\",\"esbuild\",\"prisma\",\"sharp\",\"unrs-resolver\"]" >> .npmrc

RUN pnpm install --no-frozen-lockfile

COPY . .

RUN pnpm exec prisma generate

RUN pnpm run build

RUN chown -R firefli:firefli /usr/src/app

USER firefli

EXPOSE 3000

CMD ["pnpm", "run", "start"]
