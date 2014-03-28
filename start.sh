#!/usr/bin/env bash
# when using docker mounted volumes, the owner/group is set to root
if [ `stat --format=%U /var/lib/cassandra` != "cassandra" ] ; then
  chown -R cassandra:cassandra /var/lib/cassandra
fi
if [ `stat --format=%U /var/log/cassandra` != "cassandra" ] ; then
  chown -R cassandra:cassandra /var/log/cassandra
fi
service cassandra start
tail -f /var/log/cassandra/output.log
