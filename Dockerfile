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

