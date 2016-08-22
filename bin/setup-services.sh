#!/bin/bash

mysql_install_db
chown -R mysql:mysql /var/lib/mysql
mysqld_safe --nowatch
./bin/mysqladmin -u root password 'pwd123'
