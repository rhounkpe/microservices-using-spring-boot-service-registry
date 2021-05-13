FROM openjdk:11
MAINTAINER Rufin Hounkpe <rhounkpe@gmail.com>
ADD ./target/microservices-using-spring-boot-service-registry.jar microservices-using-spring-boot-service-registry.jar
ENTRYPOINT ["java", "-jar", "/microservices-using-spring-boot-service-registry.jar"]
EXPOSE 9002
