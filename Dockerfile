FROM tomcat:7-jre8
USER root
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y vim
RUN apt-get install -y wget procps unzip

COPY tomcat-users.xml /usr/local/tomcat/conf/
RUN wget -O /usr/local/tomcat/webapps/spring-petclinic.war http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=snapshots\&g=org.springframework.samples\&a=spring-petclinic\&v=1.0-SNAPSHOT\&p=war
EXPOSE 8080
WORKDIR /usr/local/tomcat/bin/
ENTRYPOINT ["catalina.sh","run"]
