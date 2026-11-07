FROM node:22-alpine

RUN corepack enable && corepack prepare pnpm@11.9.0 --activate

RUN addgroup -S firefli && adduser -S firefli -G firefli

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./
COPY prisma ./prisma/

# Allow package build scripts
ENV PNPM_ALLOW_BUILD_SCRIPTS=*
RUN pnpm install --no-frozen-lockfile --config.onlyBuiltDependencies[]=@parcel/watcher --config.onlyBuiltDependencies[]=@prisma/engines --config.onlyBuiltDependencies[]=core-js --config.onlyBuiltDependencies[]=esbuild --config.onlyBuiltDependencies[]=prisma --config.onlyBuiltDependencies[]=sharp --config.onlyBuiltDependencies[]=unrs-resolver
COPY . .

RUN pnpm exec prisma generate

RUN pnpm run build

RUN chown -R firefli:firefli /usr/src/app

USER firefli

EXPOSE 3000

CMD ["pnpm", "run", "start"]
