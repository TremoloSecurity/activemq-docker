#!/bin/bash

cp /usr/local/activemq/conf/* /etc/amqcreds/

echo 'activemq.username=system' > /etc/amqcreds/credentials.properties
echo "activemq.password=$AMQ_TOKEN" >> /etc/amqcreds/credentials.properties
echo "guest.password=$AMQ_TOKEN" >> /etc/amqcreds/credentials.properties

export ACTIVEMQ_HOME=/etc/amqcreds

#cp /etc/amqcreds/credentials.properties /usr/local/activemq/conf/credentials.properties

# start AMQ
/usr/local/activemq/bin/activemq console xbean:file:/etc/activemq/activemq.xml