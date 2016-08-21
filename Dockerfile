FROM centos:7

# Install Required RPM Packages
RUN yum install httpd -y; yum clean all
RUN yum install mariadb-server mariadb -y; yum clean all
RUN yum install php php-mysqli -y; yum clean all

# Initialize Database Directory
RUN /usr/libexec/mariadb-prepare-db-dir

# Enable Apache
RUN systemctl enable httpd.service

# Enable MySQL/MariaDB
RUN systemctl enable mariadb.service

EXPOSE 80 443
CMD ["/usr/sbin/init"]
