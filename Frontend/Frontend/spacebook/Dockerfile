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

# Etapa 2: Servir con Nginx
FROM nginx:alpine

# Copiar los archivos construidos desde la etapa de build
COPY --from=build /app/dist/spacebook/browser /usr/share/nginx/html

# Copiar la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar script de inicio
COPY start-nginx.sh /start-nginx.sh
RUN chmod +x /start-nginx.sh

# Exponer el puerto (Cloud Run usa la variable PORT)
EXPOSE 8080

# Comando para iniciar Nginx con el puerto dinámico
CMD ["/start-nginx.sh"]
