FROM nginx

WORKDIR /usr/local/bin
RUN apt-get update && \
    apt-get install -y curl nano && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64 -o /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

run mkdir -p /etc/confd/templates
run mkdir -p /etc/confd/conf.d
run mkdir -p /etc/confd/init

COPY confd/* /etc/confd/init/

RUN mv /etc/nginx/conf.d/*.conf /etc/nginx
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old

COPY nginx.conf /etc/nginx/nginx.conf.original

COPY confd-watch /usr/local/bin/confd-watch
RUN chmod +x /usr/local/bin/confd-watch

CMD ["/usr/local/bin/confd-watch"]