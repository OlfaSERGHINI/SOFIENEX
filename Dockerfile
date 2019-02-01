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
FROM openjdk:8-jre-stretch

#Create destination folder
RUN mkdir /destination

#Copy package
COPY --from=builder /usr/src/target/spring-boot-docker-0.1.0.jar /destination/app.jar

RUN ls /destination/app.jar

#Run app
ENTRYPOINT ["java","-jar","/destination/app.jar"]
#Installer postgresql
FROM centos:centos6
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install postgresql-server postgresql postgresql-contrib supervisor; yum clean all

ADD ./postgresql-setup /usr/bin/postgresql-setup
ADD ./postgres_user.sh /postgres_user.sh
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./start_postgres.sh /start_postgres.sh

RUN chmod +x /usr/bin/postgresql-setup
RUN chmod +x /start_postgres.sh
RUN chmod +x /postgres_user.sh

RUN /usr/bin/postgresql-setup initdb

ADD ./postgresql.conf /var/lib/pgsql/data/postgresql.conf

RUN chown -v postgres.postgres /var/lib/pgsql/data/postgresql.conf

RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf

RUN /postgres_user.sh

EXPOSE 5432

CMD ["/bin/bash", "/start_postgres.sh"]
