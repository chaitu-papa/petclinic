FROM tomcat:7-jre8
USER root
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y vim
RUN apt-get install -y wget procps unzip
RUN wget -O /tmp/AppServerAgent.zip http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=releases\&g=org.springframework.samples\&a=AppServerAgent\&v=4.5.1.23676\&p=zip
#RUN wget -O /tmp/machine-agent.zip http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=releases\&g=org.springframework.samples\&a=machineagent\&v=4.5.1.1385\&p=zip

# Install AppDynamics Machine Agent
ENV APP_AGENT_HOME /opt/appdynamics/appserver-agent
RUN mkdir -p ${APP_AGENT_HOME} && \
    unzip -oq /tmp/AppServerAgent.zip -d ${APP_AGENT_HOME} && \
    rm /tmp/AppServerAgent.zip

#ENV CATALINA_OPTS "$CATALINA_OPTS -javaagent:${APP_AGENT_HOME}/javaagent.jar"

# Install AppDynamics Machine Agent
#ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent
#RUN mkdir -p ${MACHINE_AGENT_HOME} && \
#    unzip -oq /tmp/machine-agent.zip -d ${MACHINE_AGENT_HOME} && \
#   chmod -R 755 ${MACHINE_AGENT_HOME} && \
#    rm /tmp/machine-agent.zip
# Include start script to configure and start MA at runtime

#ENV Variables 
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.controller.hostName=$APPDYNAMICS_CONTROLLER_HOST_NAME"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.controller.port=$APPDYNAMICS_CONTROLLER_PORT"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.applicationName=$APPDYNAMICS_AGENT_APPLICATION_NAME"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.tierName=$APPDYNAMICS_AGENT_TIER_NAME"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.nodeName=$APPDYNAMICS_AGENT_NODE_NAME"
#ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.reuse.nodeName.prefix=$APPDYNAMICS_AGENT_NODE_NAME"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.accountName=$APPDYNAMICS_AGENT_ACCOUNT_NAME"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.accountAccessKey=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY"
#ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.reuse.nodeName=true"
ENV CATALINA_OPTS "$CATALINA_OPTS -Dappdynamics.agent.uniqueHostId=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\1/p' /proc/self/cgroup)"
ENV CATALINA_OPTS "$CATALINA_OPTS -javaagent:${APP_AGENT_HOME}/javaagent.jar"
# Configure and Run AppDynamics Machine Agent

COPY tomcat-users.xml /usr/local/tomcat/conf/
COPY start-service.sh /usr/local/tomcat/bin/start-service.sh
RUN wget -O /usr/local/tomcat/webapps/spring-petclinic.war http://34.196.120.121:8081/nexus/service/local/artifact/maven/redirect?r=snapshots\&g=org.springframework.samples\&a=spring-petclinic\&v=1.0-SNAPSHOT\&p=war
EXPOSE 8080
WORKDIR /usr/local/tomcat/bin/
ENTRYPOINT ["catalina.sh","run"]
