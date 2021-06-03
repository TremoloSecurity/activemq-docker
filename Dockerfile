FROM ubuntu:18.04

MAINTAINER Tremolo Security, Inc. - Docker <docker@tremolosecurity.com>

ENV JDK_VERSION=1.8.0 \
    ACTIVEMQ_VERSION=5.16.2 \
    DBCP_VERSION=1.2.2 \
    MYSQL_VERSION=8.0.12 \
    MARIADB_VERSION=2.3.0 \
    COMMONS_POOL_VERSION=1.6 \
    MS_SQL_SERVER_VERSION=7.0.0.jre8

LABEL io.k8s.description="Platform for deploying kubernetes artifacts" \
      io.k8s.display-name="Kubernetes Artifact Deployer" 

RUN groupadd -r activemq -g 433 && \
    useradd -u 431 -r -g activemq -d /usr/local/activemq -s /sbin/nologin -c "ActiveMQ Docker image user" activemq && \
    mkdir /usr/local/activemq

ADD health_check.sh /usr/bin/health_check.sh

RUN apt-get update;apt-get -y install openjdk-8-jdk-headless curl apt-transport-https gnupg jq && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update; apt-get install -y kubectl ; apt-get -y upgrade;apt-get clean;rm -rf /var/lib/apt/lists/*; \
    cd /tmp && \
    curl -L -o /tmp/apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz http://www.apache.org/dyn/closer.cgi?filename=/activemq/$ACTIVEMQ_VERSION/apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz\&action=download && \
    tar -xvzf apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz && \
    mv apache-activemq-$ACTIVEMQ_VERSION/* /usr/local/activemq/ && \
    curl -L -o /usr/local/activemq/lib/commons-dbcp-$DBCP_VERSION.jar  https://search.maven.org/remotecontent?filepath=commons-dbcp/commons-dbcp/$DBCP_VERSION/commons-dbcp-$DBCP_VERSION.jar && \
    curl -L -o /usr/local/activemq/lib/mysql-connector-java-$MYSQL_VERSION.jar https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar && \
    curl -L -o /usr/local/activemq/lib/mariadb-java-client-$MARIADB_VERSION.jar https://search.maven.org/remotecontent?filepath=org/mariadb/jdbc/mariadb-java-client/$MARIADB_VERSION/mariadb-java-client-$MARIADB_VERSION.jar && \
    curl -L -o /usr/local/activemq/lib/commons-pool-$COMMONS_POOL_VERSION.jar https://search.maven.org/remotecontent?filepath=commons-pool/commons-pool/$COMMONS_POOL_VERSION/commons-pool-$COMMONS_POOL_VERSION.jar && \
    curl -L -o /usr/local/activemq/lib/mssql-jdbc-$MS_SQL_SERVER_VERSION.jar https://search.maven.org/remotecontent?filepath=com/microsoft/sqlserver/mssql-jdbc/$MS_SQL_SERVER_VERSION/mssql-jdbc-$MS_SQL_SERVER_VERSION.jar && \
    chown -R activemq:activemq /usr/local/activemq && \
    chmod +x /usr/bin/health_check.sh

USER 431

CMD ["/usr/local/activemq/bin/activemq",  "console","xbean:file:/etc/activemq/activemq.xml"]


