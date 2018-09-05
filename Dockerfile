FROM tomcat:7-jre8
USER root
RUN apt-get update 
RUN apt-get install -y vim
RUN apt-get install -y wget procps unzip
RUN wget -O /tmp/AppServerAgent.zip http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=releases\&g=org.springframework.samples\&a=AppServerAgent\&v=4.5.1.23676\&p=zip
RUN wget -O /tmp/machine-agent.zip http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=releases\&g=org.springframework.samples\&a=machineagent\&v=4.5.0.1285\&p=zip
# Install AppDynamics Machine Agent
ENV APP_AGENT_HOME /opt/appdynamics/appserver-agent
RUN mkdir -p ${APP_AGENT_HOME} && \
    unzip -oq /tmp/AppServerAgent.zip -d ${APP_AGENT_HOME} && \
    rm /tmp/AppServerAgent.zip

ENV CATALINA_OPTS "$CATALINA_OPTS -javaagent:${APP_AGENT_HOME}/javaagent.jar"

# Install AppDynamics Machine Agent
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent
RUN mkdir -p ${MACHINE_AGENT_HOME} && \
    unzip -oq /tmp/machine-agent.zip -d ${MACHINE_AGENT_HOME} && \
   chmod -R 755 ${MACHINE_AGENT_HOME} && \
    rm /tmp/machine-agent.zip
# Include start script to configure and start MA at runtime

# Configure and Run AppDynamics Machine Agent

COPY tomcat-users.xml /usr/local/tomcat/conf/
COPY start-service.sh /usr/local/tomcat/bin/start-service.sh
RUN wget -O /usr/local/tomcat/webapps/spring-petclinic.war http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=snapshots\&g=org.springframework.samples\&a=spring-petclinic\&v=1.0-SNAPSHOT\&p=war
WORKDIR /usr/local/tomcat/bin/
#CMD "start-service.sh"
