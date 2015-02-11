#!/bin/bash

#PW=$(</dev/urandom tr -dc A-Za-z0-9 | head -c12)
source /etc/zabbix/zabbix_server.conf
PW=${DBPassword:-xlands}

mysql -uroot -S ${DBSocket} <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost   identified by '${PW}';
grant all privileges on zabbix.* to zabbix@'127.0.0.1' identified by '${PW}';
grant all privileges on zabbix.* to zabbix@'172.%'     identified by '${PW}';
EOF

zcat /data/"${VER}"/*gz | mysql -uroot -S ${DBSocket} zabbix && \
  touch /logs/mysql-init-${VER}.lock
