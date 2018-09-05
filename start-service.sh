#!/bin/bash

# Start the first process
"/usr/local/tomcat/bin/catalina.sh start" 

# Start the second process
"/opt/appdynamics/machine-agent/bin/machine-agent &"

