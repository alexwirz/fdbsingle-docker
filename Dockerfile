FROM ubuntu

# pre-reqs
RUN apt-get update && apt-get -y install python wget supervisor python-setuptools
RUN easy_install supervisor

# Prevent initialization by installer
RUN mkdir -p /etc/foundationdb && touch /etc/foundationdb/fdb.cluster

# fdb server
RUN wget https://www.foundationdb.org/downloads/5.1.5/ubuntu/installers/foundationdb-clients_5.1.5-1_amd64.deb
RUN wget https://www.foundationdb.org/downloads/5.1.5/ubuntu/installers/foundationdb-server_5.1.5-1_amd64.deb
RUN dpkg -i foundationdb-clients_5.1.5-1_amd64.deb foundationdb-server_5.1.5-1_amd64.deb

RUN mv /etc/foundationdb/foundationdb.conf /usr/lib/foundationdb/foundationdb.conf.orig
RUN rm /etc/foundationdb/fdb.cluster
RUN rm -rf /var/lib/foundationdb/data

# VOLUME ["/etc/foundationdb", "/fdb-data"]

# fdb server
EXPOSE 4500

ADD docker-start.sh /usr/lib/foundationdb/
ADD foundationdb.conf /etc/foundationdb/foundationdb.conf

RUN mkdir -p /data
RUN mkdir -p /logs
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]

