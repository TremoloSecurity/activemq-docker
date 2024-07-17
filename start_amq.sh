#!/bin/bash



cp /usr/local/activemq/confbak/* /usr/local/activemq/conf/

rm /usr/local/activemq/conf/credentials.properties

echo 'activemq.username=system' > /usr/local/activemq/conf/credentials.properties
echo "activemq.password=$AMQ_TOKEN" >> /usr/local/activemq/conf/credentials.properties
echo "guest.password=$AMQ_TOKEN" >> /usr/local/activemq/conf/credentials.properties



#cp /etc/amqcreds/credentials.properties /usr/local/activemq/conf/credentials.properties

# start AMQ
/usr/local/activemq/bin/activemq console xbean:file:/etc/activemq/activemq.xml