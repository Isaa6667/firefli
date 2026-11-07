FROM node:22-alpine

# Install a fixed pnpm version
RUN corepack enable && corepack prepare pnpm@11.9.0 --activate

# Create non-root user
RUN addgroup -S firefli && adduser -S firefli -G firefli

WORKDIR /usr/src/app

# Copy dependency files
COPY package.json pnpm-lock.yaml ./
COPY prisma ./prisma/

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Generate Prisma client
RUN pnpm exec prisma generate

# Copy source code
COPY . .

# Build application
RUN pnpm run build

# Set permissions
RUN chown -R firefli:firefli /usr/src/app

USER firefli

EXPOSE 3000

CMD ["pnpm", "run", "start"]