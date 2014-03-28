FROM ubuntu:12.10

RUN apt-get update
RUN apt-get install -yq software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -yq oracle-java7-installer

RUN echo "deb http://debian.datastax.com/community stable main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
RUN wget -q -O - http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update
RUN apt-get install -yq dsc12=1.2.15-1 cassandra=1.2.15

VOLUME /var/lib/cassandra
VOLUME /var/log/cassandra

EXPOSE 9160
ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh