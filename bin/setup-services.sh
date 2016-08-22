#!/bin/bash

mysql_install_db > /dev/null 2>&1
chown -R mysql:mysql /var/lib/mysql
mysqld_safe --nowatch
mysqladmin -u root password 'pwd123'
