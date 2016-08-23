# Image
FROM centos:7

# Timezone
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

# Shared folder that will be mounted
RUN mkdir /DOCKER_FS

# Update all
RUN yum -y update

# Install repositories
RUN yum -y install epel-release
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install basic packages
RUN yum -y install wget tar gcc telnet nano

# Install supervisord
RUN yum --enablerepo=epel -y install supervisor
RUN mv -f /etc/supervisord.conf /etc/supervisord.conf-BKP
ADD etc/supervisord.conf /etc/

# Install rsyslogd
RUN yum install -y rsyslog

# Install crond
RUN yum install -y cronie-noanacron
# no PAM
RUN cp -a /etc/pam.d/crond /etc/pam.d/crond-BKP
RUN sed -i -e 's/^\(session\s\+required\s\+pam_loginuid\.so\)/#\1/' /etc/pam.d/crond

# Install sshd
RUN yum install -y openssh-server openssh-clients sudo
# no PAM
# http://stackoverflow.com/questions/18173889/cannot-access-centos-sshd-on-docker
RUN cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config-BKP
RUN sed -i -e 's/^\(UsePAM\s\+.\+\)/#\1/gi' /etc/ssh/sshd_config
RUN echo -e '\nUsePAM no' >> /etc/ssh/sshd_config

RUN echo 'root:root' | chpasswd
# no direct ROOT login
RUN sed -i -e 's/^\(PermitRootLogin\s\+.\+\)/#\1/gi' /etc/ssh/sshd_config
RUN echo -e '\nPermitRootLogin no' >> /etc/ssh/sshd_config

RUN useradd -g wheel devuser
RUN echo 'devuser:devuser' | chpasswd
RUN sed -i -e 's/^\(%wheel\s\+.\+\)/#\1/gi' /etc/sudoers
RUN echo -e '\n%wheel ALL=(ALL) ALL' >> /etc/sudoers

# allow sudo without tty for ROOT user and WHEEL group
# http://qiita.com/ryo0301/items/4daf5a6d22f16193410f
RUN echo -e '\nDefaults:root   !requiretty' >> /etc/sudoers
RUN echo -e '\nDefaults:%wheel !requiretty' >> /etc/sudoers

# Install LAMP
RUN yum -y install mariadb-server php70w php70w-devel php70w-mysql php70w-gd \
php70w-pear php70w-cli php70w-pdo php70w-xml php70w-process php70w-mcrypt \
php70w-mbstring php70w-mysql php70w-tidy php70w-soap

# Initialize Database Directory
#RUN /usr/libexec/mariadb-prepare-db-dir

# Enable Apache
#RUN systemctl enable httpd.service
#RUN systemctl enable mariadb.service

EXPOSE 80 443 22

RUN mkdir /root/install
ADD bin/setup-services.sh /root/install
RUN chmod +rx /root/install/*
#RUN /root/install/setup-services.sh

# ENTRYPOINT ["/usr/bin/supervisord"] does not work.
# --> "Error: positional arguments are not supported"
# http://stackoverflow.com/questions/22465003/error-positional-arguments-are-not-supported
CMD ["/usr/bin/supervisord"]


