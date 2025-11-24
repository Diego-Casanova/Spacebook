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

# Copiar template de configuración de Nginx
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copiar script de inicio
COPY start-nginx.sh /start-nginx.sh
RUN chmod +x /start-nginx.sh

# Exponer el puerto (Cloud Run usa la variable PORT)
EXPOSE 8080

# Comando para iniciar Nginx con el puerto dinámico
CMD ["/start-nginx.sh"]
