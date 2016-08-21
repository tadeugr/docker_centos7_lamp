FROM centos:7

RUN mkdir /DOCKER_FS

RUN yum -y update

RUN yum -y install epel-release

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum -y install telnet nano mariadb-server php70w php70w-devel php70w-mysql php70w-gd \
php70w-pear php70w-cli php70w-pdo php70w-xml php70w-process php70w-mcrypt \
php70w-mbstring php70w-mysql php70w-tidy php70w-soap

# Initialize Database Directory
#RUN /usr/libexec/mariadb-prepare-db-dir

# Enable Apache
RUN systemctl enable httpd.service

# Enable MySQL/MariaDB
RUN systemctl enable mariadb.service

EXPOSE 80 443
CMD ["/usr/sbin/init"]
