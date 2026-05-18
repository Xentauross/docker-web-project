# syntax=docker/dockerfile:1.4

# ── STAGE 1: Dependencies ─────────────────────────────
FROM --platform=$BUILDPLATFORM node:18-alpine AS development

WORKDIR /app
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
RUN npm ci
COPY . /app

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]

# ── STAGE 2: Build of production ──────────────────────
FROM development AS build
RUN npm run build

# ── STAGE 3: Final image (production) ─────────
FROM nginx:alpine AS production

COPY --from=build /app/build /usr/share/nginx/html

# Add configuration to prevent 404 errors in React Router
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
