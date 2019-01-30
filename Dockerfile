FROM maven:3.5-jdk-8

CMD mvn clean install

ADD target/spring-boot-docker-0.1.0.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]

