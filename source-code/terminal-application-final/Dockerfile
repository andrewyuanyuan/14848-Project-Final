FROM nginx
EXPOSE 80
RUN rm -f /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html
COPY replace.sh .
RUN sed -i '/set -e/ash /replace.sh' /docker-entrypoint.sh