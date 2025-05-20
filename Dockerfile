FROM nginx:alpine

# Copier les fichiers de l'interface
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/

# Configuration Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 