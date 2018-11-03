#!/bin/bash
set -e -x

iptables -A INPUT -s 0.0.0.0/0 -p tcp -m state --state NEW --dport 22 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -s 0.0.0.0/0 -p tcp -m state --state NEW --dport 80 -j ACCEPT
iptables -A INPUT -j DROP
iptables-save > /etc/sysconfig/iptables

yum clean all && yum repolist
yum install -y docker
service docker start
chkconfig docker on
docker run -ti -d -p 80:80 --name test_nginx nginx
STATUS=`docker inspect -f '{{.State.Running}}' test_nginx`
if [ $STATUS == true ]
then
echo "test_nginx is running"
else
echo "test_nginx is not running"
fi
curl http://localhost > /tmp/test_nginx_default.txt
sed -e 's/<[^>]*>//g' /tmp/test_nginx_default.txt | tr 'A-Z' 'a-z' | sed 's/\./ /g' | sed 's/[^a-z ]//g' | tr -s '[[:space:]]' '\n' | sort | uniq -c | sort -n | tail -n1
echo "*/10 * * * * root docker stats --no-stream test_nginx >> /tmp/test_nginx_stats.txt" >> /etc/crontab
service crond start
chkconfig crond on
