FROM debian:jessie
MAINTAINER hervenicol

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
 && apt-get install -y apache2 && apt-get clean
RUN a2enmod proxy_fcgi

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

RUN sed -e 's/ErrorLog.*/ErrorLog \/proc\/self\/fd\/2/' \
        -e 's/CustomLog.*/CustomLog \/proc\/self\/fd\/1 combined/' \
        -e '/<\/VirtualHost>/d' \
        -i /etc/apache2/sites-available/000-default.conf && \
    sed -e '/APACHE_RUN_USER/s/^/#/' \
        -e '/APACHE_RUN_GROUP/s/^/#/' \
        -i /etc/apache2/envvars && \
    echo "ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://\${PHP_SERVER}/\$1" >> /etc/apache2/sites-available/000-default.conf && \
    echo "DirectoryIndex /index.php index.php" >> /etc/apache2/sites-available/000-default.conf && \
    echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

EXPOSE 80

LABEL description="Jessie / Apache 2.4"

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

