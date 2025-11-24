#!/bin/sh

# Usar el puerto de la variable de entorno PORT o 8080 por defecto
PORT=${PORT:-8080}

# Reemplazar el puerto en la configuración de Nginx
sed -i "s/listen 8080;/listen ${PORT};/g" /etc/nginx/nginx.conf

# Iniciar Nginx
exec nginx -g "daemon off;"
