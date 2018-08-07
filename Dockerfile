FROM centos:centos7
LABEL maintainer=" Moses Raja<moses.raja@gmail.com>"

ENV nginxversion="1.12.2-1" \
    os="centos" \
    osversion="7" \
    elversion="7_4"

VOLUME ["/var/www/html" , "/usr/share/nginx/html" ]

RUN yum install -y wget curl openssl sed initscripts &&\
    yum -y autoremove &&\
    yum clean all &&\
    wget http://nginx.org/packages/$os/$osversion/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    sed -i '1i\
    daemon off;\
    ' /etc/nginx/nginx.conf


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all


RUN sed -i '1i\ServerName www.mosestest.com\' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install yum-utils && \
    yum-config-manager --enable remi-php70 && \
    yum update -y && \
    yum install -y \
    php70-php.x86_64 \
    php70-php-bcmath.x86_64 \
    php70-php-cli.x86_64 \
    php70-php-common.x86_64 \
    php70-php-devel.x86_64 \
    php70-php-gd.x86_64 \
    php70-php-intl.x86_64 \
    php70-php-json.x86_64 \
    php70-php-mbstring.x86_64 \
    php70-php-mcrypt.x86_64 \
    php70-php-mysqlnd.x86_64 \
    php70-php-pdo.x86_64 \
    php70-php-pear.noarch \
    php70-php-xml.x86_64 \
    php70-php-ast.x86_64 \
    php70-php-opcache.x86_64 \
    php70-php-pecl-zip.x86_64 \
    php70-php-pecl-memcached.x86_64 && \
    ln -s /usr/bin/php70 /usr/bin/php && \
    ln -s /etc/opt/remi/php70/php.ini /etc/php.ini && \
    ln -s /etc/opt/remi/php70/php.d /etc/php.d && \
    ln -s /etc/opt/remi/php70/pear.conf /etc/pear.conf && \
    ln -s /etc/opt/remi/php70/pear /etc/pear


RUN yum install -y httpd-devel.x86_64 && \
    yum install -y mod_ssl


RUN yum --enablerepo=centosplus install mod_php

RUN usermod -u 1000 apache && ln -sf /dev/stdout /var/log/httpd/access_log && ln -sf /dev/stderr /var/log/httpd/error_log


RUN rm /etc/httpd/conf.d/welcome.conf \
    && sed -i -e "s/Options\ Indexes\ FollowSymLinks/Options\ -Indexes\ +FollowSymLinks/g" /etc/httpd/conf/httpd.conf \
    && sed -i "s/\/var\/www\/html/\/var\/www/g" /etc/httpd/conf/httpd.conf \
    && echo "FileETag None" >> /etc/httpd/conf/httpd.conf \
    && sed -i -e "s/expose_php\ =\ On/expose_php\ =\ Off/g" /etc/php.ini \
    && sed -i -e "s/\;error_log\ =\ php_errors\.log/error_log\ =\ \/var\/log\/php_errors\.log/g" /etc/php.ini \
    && echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf \
    && echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf
    
RUN yum install -y httpd-tools \
    && mkdir /etc/htpasswd \
    && htpasswd -cb /etc/htpasswd/.htpasswd moses moses \
    && mkdir /var/www/media \
    && wget http://webpagepublicity.com/free-fonts/a/Airmole.ttf -P /var/www/media/ \
    && mkdir /var/www/protected \
    && mkdir /etc/ssl/private \
    && touch /var/www/protected/moses.txt

RUN echo " This is a protected file with authorized userse" >> /var/www/protected/moses.txt

RUN yum clean all

EXPOSE 80

EXPOSE 8080
EXPOSE 443

ADD index.php /var/www/index.php
ADD nginx.conf  /etc/nginx/nginx.conf
ADD ssl.conf /etc/httpd/conf/ssl.conf
ADD apache-selfsigned.crt /etc/ssl/certs/apache-selfsigned.crt
ADD apache-selfsigned.key /etc/ssl/private/apache-selfsigned.key
ADD httpd.conf /etc/httpd/conf/httpd.conf
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh


ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
