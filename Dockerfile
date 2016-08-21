FROM centos:7

# Install Required RPM Packages
RUN yum install httpd -y; yum clean all
