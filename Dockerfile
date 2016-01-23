FROM debian:jessie
MAINTAINER hervenicol

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
 && apt-get install -y apache2 && apt-get clean
RUN a2enmod proxy_fcgi

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN sed -e 's/ErrorLog.*/ErrorLog syslog:user/' \
        -e '/<\/VirtualHost>/d' \
        -i /etc/apache2/sites-available/000-default.conf && \
    echo "ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://172.17.0.1:9000/\$1" >> /etc/apache2/sites-available/000-default.conf && \
    echo "DirectoryIndex /index.php index.php" >> /etc/apache2/sites-available/000-default.conf && \
    echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

EXPOSE 80

LABEL description="Jessie / Apache 2.4"

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

