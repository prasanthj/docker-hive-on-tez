FROM prasanthj/docker-tez:tez-0.5.2
MAINTAINER Prasanth Jayachandran

# to configure postgres as hive metastore backend
RUN apt-get update
RUN apt-get -yq install vim postgresql-9.3 libpostgresql-jdbc-java

# create metastore db, hive user and assign privileges
USER postgres
RUN /etc/init.d/postgresql start &&\
     psql --command "CREATE DATABASE metastore;" &&\
     psql --command "CREATE USER hive WITH PASSWORD 'hive';" && \
     psql --command "ALTER USER hive WITH SUPERUSER;" && \
     psql --command "GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;"
     
# revert back to default user
USER root
            
# download hive and set environment
ENV HIVE_VERSION 0.14.0
RUN curl -s http://www.us.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar -xz -C /usr/local
RUN cd /usr/local && ln -s apache-hive-${HIVE_VERSION}-bin hive
ENV HIVE_HOME /usr/local/hive
ENV HIVE_CONF $HIVE_HOME/conf
ENV PATH $HIVE_HOME/bin:$PATH

# add postgresql jdbc jar to classpath
RUN ln -s /usr/share/java/postgresql-jdbc4.jar $HIVE_HOME/lib/postgresql-jdbc4.jar

# to avoid psql asking password, set PGPASSWORD
ENV PGPASSWORD hive

# initialize hive metastore db
RUN /etc/init.d/postgresql start &&\
	cd $HIVE_HOME/scripts/metastore/upgrade/postgres/ &&\
 	psql -h localhost -U hive -d metastore -f hive-schema-${HIVE_VERSION}.postgres.sql

# copy config, sql, data files to /opt/files
RUN mkdir /opt/files
ADD hive-site.xml /opt/files/
ADD hive-log4j.properties /opt/files/
ADD hive-site.xml $HIVE_CONF/hive-site.xml
ADD hive-log4j.properties $HIVE_CONF/hive-log4j.properties
ADD store_sales.* /opt/files/
ADD datagen.py /opt/files/

# set permissions for hive bootstrap file
ADD hive-bootstrap.sh /etc/hive-bootstrap.sh
RUN chown root:root /etc/hive-bootstrap.sh
RUN chmod 700 /etc/hive-bootstrap.sh

# To overcome the bug in AUFS that denies postgres permission to read /etc/ssl/private/ssl-cert-snakeoil.key file.
# https://github.com/Painted-Fox/docker-postgresql/issues/30
# https://github.com/docker/docker/issues/783
# To avoid this issue lets disable ssl in postgres.conf. If we really need ssl to encrypt postgres connections we have to fix permissions to /etc/ssl/private directory everytime until AUFS fixes the issue
ENV POSTGRESQL_MAIN /var/lib/postgresql/9.3/main/
ENV POSTGRESQL_CONFIG_FILE $POSTGRESQL_MAIN/postgresql.conf
ENV POSTGRESQL_BIN /usr/lib/postgresql/9.3/bin/postgres
ADD postgresql.conf $POSTGRESQL_MAIN
RUN chown postgres:postgres $POSTGRESQL_CONFIG_FILE
