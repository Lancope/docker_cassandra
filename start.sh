#!/usr/bin/env bash
# when using docker mounted volumes, the owner/group is set to root
if [ `stat --format=%U /var/lib/cassandra` != "cassandra" ] ; then
  chown -R cassandra:cassandra /var/lib/cassandra
fi
if [ `stat --format=%U /var/log/cassandra` != "cassandra" ] ; then
  chown -R cassandra:cassandra /var/log/cassandra
fi
IP=$(ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
sed -i -e "s/^\(listen_address:\).*/\1 $IP/" /etc/cassandra/cassandra.yaml
sed -i -e "s/^\([ ]*- seeds:\).*/\1 $IP/" /etc/cassandra/cassandra.yaml
start-stop-daemon --chuid cassandra:cassandra --exec /usr/sbin/cassandra --start -- -f
