FROM ubuntu:12.10

# add source for webupd8 java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu quantal main" | tee -a /etc/apt/sources.list.d/java.sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
# add source for cassandra
RUN echo "deb http://debian.datastax.com/community stable main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 350200F2B999A372
RUN apt-get update

# install java
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -yq oracle-java7-installer

# install cassandra
RUN apt-get install -yq dsc12=1.2.15-1 cassandra=1.2.15
RUN sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml

VOLUME ["/var/lib/cassandra", "/var/log/cassandra"]
EXPOSE 9160

ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh