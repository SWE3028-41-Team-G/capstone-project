FROM node:20.18.0-alpine AS builder

COPY . /build
WORKDIR /build

RUN corepack enable
RUN pnpm --filter=backend deploy out

WORKDIR /build/out
RUN npx prisma generate
RUN npm run build

### PRODUCTION ###
FROM node:20.18.0-alpine

ENV NODE_ENV=production

COPY --from=builder /build/out /app
COPY ./apps/backend/entrypoint.sh /app
WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh"]
