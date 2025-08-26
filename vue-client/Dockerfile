ARG NODE_VERSION=22.15.1-alpine
ARG NGINX_VERSION=alpine3.21

FROM node:${NODE_VERSION} AS builder

# Create and set /app as working directory
WORKDIR /app

# Copy package.json and package-lock.json to current work directory(/app)
COPY package.json package-lock.json ./

# Install project dependencies using npm ci(npm clean install)
RUN --mount=type=cache,target=/root/.npm npm ci

# Copy everything to the the container
COPY . .

RUN npm run build

# =========================================
# Stage 2: Prepare Nginx to Serve Vue app
# =========================================

FROM nginxinc/nginx-unprivileged:${NGINX_VERSION} AS runner

# Using nginx user
USER nginx

# Copy nginx to nginx directory
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built directory from /app/dist to /usr/share/nginx/html
COPY --chown=nginx:nginx --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080

ENTRYPOINT [ "nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]

