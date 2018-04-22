#/bin/bash

if [ ! -f /etc/foundationdb/foundationdb.conf ]; then
    cp /usr/lib/foundationdb/foundationdb.conf.orig /etc/foundationdb/foundationdb.conf
fi

if [ ! -f /etc/foundationdb/fdb.cluster ]; then
    ADDR=127.0.0.1
    echo "docker:d3c9f2ccfca44ee7b03caf2e6dbe4d25@$ADDR:4500" >/etc/foundationdb/fdb.cluster
    chmod 0644 /etc/foundationdb/fdb.cluster
    NEWDB=yes
fi

service foundationdb start

CMD=status
if [ "$NEWDB" = "yes" ]; then
  CMD="configure new single memory; status"
fi

fdbcli --exec "$CMD" --timeout 60
