# Etapa 1: Construcción
FROM node:20-alpine AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci --legacy-peer-deps

# Copiar el código fuente
COPY . .

# Construir la aplicación para producción
RUN npm run build

# Listar el contenido para debug
RUN echo "Contenido de /app/dist:" && ls -la /app/dist/ || echo "dist no existe"
RUN echo "Contenido de /app/dist/spacebook:" && ls -la /app/dist/spacebook/ || echo "spacebook no existe"

# Etapa 2: Servir con Nginx
FROM nginx:alpine

# Copiar los archivos construidos desde la etapa de build
COPY --from=build /app/dist/spacebook/browser /usr/share/nginx/html

# Verificar que se copiaron los archivos
RUN echo "Contenido de /usr/share/nginx/html:" && ls -la /usr/share/nginx/html/

# Crear configuración de Nginx directamente
RUN rm /etc/nginx/conf.d/default.conf && \
    cat > /etc/nginx/nginx.conf <<'EOF'
events {
    worker_connections 1024;
}
http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    server {
        listen 8080;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;
        gzip on;
        gzip_vary on;
        gzip_min_length 1024;
        gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;
        location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        location / {
            try_files $uri $uri/ /index.html;
        }
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
    }
}
EOF

# Exponer el puerto
EXPOSE 8080

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
