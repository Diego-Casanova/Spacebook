#!/bin/sh
set -e

# Usar el puerto de la variable de entorno PORT o 8080 por defecto
PORT=${PORT:-8080}

echo "Starting Nginx on port $PORT"

# Generar la configuración de Nginx con el puerto correcto usando envsubst
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Verificar que los archivos estén en su lugar
if [ ! -f "/usr/share/nginx/html/index.html" ]; then
    echo "ERROR: index.html not found!"
    echo "Contents of /usr/share/nginx/html/:"
    ls -la /usr/share/nginx/html/ || echo "Directory does not exist"
    exit 1
fi

echo "Files found in /usr/share/nginx/html/:"
ls -la /usr/share/nginx/html/

# Mostrar la configuración para debug
echo "Nginx configuration:"
cat /etc/nginx/nginx.conf

# Iniciar Nginx
echo "Starting Nginx..."
exec nginx -g "daemon off;"
