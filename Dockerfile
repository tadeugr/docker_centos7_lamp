FROM centos:7

RUN yum -y update

RUN yum -y install wget which nano openssh-server git mysql-server mysql httpd php-mysql \
        php-gd php-mcrypt php-zip php-xml php-iconv php-curl php-soap php-simplexml \
			  php-pdo php-dom php-cli tar \
			  php-hash php-mysql vixie-cron backupninja duplicity dialog

RUN yum -y install httpd
RUN yum install mariadb-server mariadb -y; yum lcean all
RUN yum install php php-mysqli -y; yum clean all

# Initialize Database Directory
RUN /usr/libexec/mariadb-prepare-db-dir

# Enable Apache
RUN systemctl enable httpd.service

# Enable MySQL/MariaDB
RUN systemctl enable mariadb.service

EXPOSE 80 443
CMD ["/usr/sbin/init"]
