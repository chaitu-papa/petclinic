FROM tomcat:7-jre8
RUN apt-get update 
RUN apt-get install -y wget
RUN apt-get install -y vim
COPY tomcat-users.xml /usr/local/tomcat/conf/
RUN wget -O /usr/local/tomcat/webapps/customerApp.war http://34.230.64.136:8081/nexus/service/local/artifact/maven/redirect?r=snapshots\&g=com.cts\&a=customerApp\&v=0.1-SNAPSHOT\&p=war
