#Download base image Centos 7
FROM centos:centos7

ENV nginxversion="1.12.2-1" \ os="centos" \ osversion="7" \ elversion="7.4"

# Install nginx
RUN yum -y install wget openssl sed curl && \
    yum -y autoremove && \
    yum clean all && \
#RUN wget http://nginx.org/packages/$os/$osversion/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm
    wget http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.12.2-1.el7_4.ngx.x86_64.rpm && \
    rpm -iv nginx-1.12.2-1.el7_4.ngx.x86_64.rpm && \
#   rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm && \
    sed -i '1i \daemon off;\' /etc/nginx/nginx.conf

CMD ["nginx"]
EXPOSE 80
CMD service nginx start
