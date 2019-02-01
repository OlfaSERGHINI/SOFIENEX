#################### BUILD STEP
FROM maven:3.5-jdk-8 as builder

#Working directory
WORKDIR /usr/src

#Copy project
COPY . .

#Check content
RUN ls /usr/src

#Package
RUN mvn package -DskipTests

################### RUN STP
FROM java:8-jre-alpine

#Create destination folder
RUN mkdir /destination

#Copy package
COPY --from=builder /usr/src/target/spring-boot-docker-0.1.0.jar /destination/app.jar

RUN ls /destination/app.jar

#Run app
ENTRYPOINT ["java","-jar","/destination/app.jar"]
#Installer postgresql
FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release; yum clean all
RUN yum -y install postgresql-server postgresql postgresql-contrib supervisor pwgen; yum clean all

ADD ./postgresql-setup /usr/bin/postgresql-setup
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./start_postgres.sh /start_postgres.sh

#Sudo requires a tty. fix that.
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers
RUN chmod +x /usr/bin/postgresql-setup
RUN chmod +x /start_postgres.sh

RUN /usr/bin/postgresql-setup initdb

ADD ./postgresql.conf /var/lib/pgsql/data/postgresql.conf

RUN chown -v postgres.postgres /var/lib/pgsql/data/postgresql.conf

RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf

VOLUME ["/var/lib/pgsql"]

EXPOSE 5432

CMD ["/bin/bash", "/start_postgres.sh"]



#Installer apache2 :/
FROM centos:7
MAINTAINER The CentOS Project <cloud-ops@centos.org>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]

