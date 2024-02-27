# Stage 1: Base stage
FROM node:14 as base
WORKDIR /app
COPY package*.json ./

# Stage 2: Development stage
FROM base as development
RUN npm install
COPY . .
CMD ["npm", "run", "start:dev"]

# Stage 3: Builder stage
FROM base as builder
RUN npm install --only=production
COPY . .
RUN npm run build

# Stage 4: Production stage
FROM node:14-alpine as production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
CMD ["node", "dist/main"]

# Stage 5: MongoDB stage
FROM mongo:4.2-bionic
COPY init-mongo.js /docker-entrypoint-initdb.d/
EXPOSE 27017
CMD ["mongod"]