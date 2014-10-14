#!/usr/bin/env bash
# when using docker mounted volumes, the owner/group is set to root
if [ `stat --format=%U /var/lib/cassandra` != "cassandra" ] ; then
  chown -R cassandra:cassandra /var/lib/cassandra
fi
if [ `stat --format=%U /var/log/cassandra` != "cassandra" ] ; then
  chown -R cassandra:cassandra /var/log/cassandra
fi

# Get container's IP
# pass in CASSANDRA_IP to use host IP
if [ -z "$CASSANDRA_IP" ] ; then
  IP=`hostname --ip-address`
else
  IP="$CASSANDRA_IP"
fi

# If given a single arg, treat arg as existing SEED and add self as seed
# Otherwise, just add self as seed
if [ $# == 1 ]; then SEEDS="$1,$IP";
else SEEDS="$IP"; fi

# Setup cluster name
if [ -z "$CASSANDRA_CLUSTERNAME" ]; then
  echo "No cluster name specified, preserving default one"
else
  sed -i -e "s/^cluster_name:.*/cluster_name: $CASSANDRA_CLUSTERNAME/" /etc/cassandra/cassandra.yaml
fi

# Listen on IP:port of the container/host
sed -i -e "s/^listen_address.*/listen_address: $IP/" /etc/cassandra/cassandra.yaml

# Configure Cassandra seeds
if [ -z "$CASSANDRA_SEEDS" ]; then
	echo "No seeds specified, being my own seed..."
	CASSANDRA_SEEDS=$SEEDS
fi
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$CASSANDRA_SEEDS\"/" /etc/cassandra/cassandra.yaml

start-stop-daemon --chuid cassandra:cassandra --exec /usr/sbin/cassandra --start -- -f
