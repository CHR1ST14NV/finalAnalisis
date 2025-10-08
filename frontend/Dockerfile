FROM node:20-alpine AS deps
WORKDIR /app
COPY frontend/package.json ./
RUN npm i --no-audit --no-fund

FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY frontend .
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production PORT=3000
RUN npm i -g serve@14.2.3 --no-audit --no-fund
COPY --from=build /app/dist ./dist
EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
