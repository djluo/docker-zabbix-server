FROM       centos:centos6
MAINTAINER djluo <dj.luo@baoyugame.com>

ADD http://mirrors.163.com/.help/CentOS6-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo

RUN export http_proxy="http://172.17.42.1:8080/"    \
    && yum makecache \
    && yum -y install http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm \
    && yum -y install net-snmp-devel net-snmp-libs net-snmp \
                      net-snmp-perl  net-snmp-python net-snmp-utils mysql \
    && yum -y install --nogpgcheck \
           https://github.com/dkanbier/docker-zabbix-server/raw/master/zabbix/zabbix-server-mysql-2.4.3-1.el6.x86_64.rpm \
    && yum clean all \
    && unset http_proxy \
    && rm -rf usr/share/locale \
    && rm -rf usr/share/man    \
    && rm -rf usr/share/info

ENV VER 2.4.3

ADD ./data/         /data
ADD ./init.sh       /init.sh
ADD ./entrypoint.pl /entrypoint.pl

ENTRYPOINT ["/entrypoint.pl"]
CMD        ["/usr/sbin/zabbix_server", "-f"]
