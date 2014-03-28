#!/usr/bin/env bash
# when using docker mounted volumes, the owner/group is set to root
if [ `stat --format=%U /var/lib/cassandra` != "cassandra" ] ; then
  chown -R /var/lib/cassandra cassandra:cassandra
fi
if [ `stat --format=%U /var/log/cassandra` != "cassandra" ] ; then
  chown -R /var/log/cassandra cassandra:cassandra
fi
/usr/sbin/cassandra -f