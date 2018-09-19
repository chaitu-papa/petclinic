#!/bin/bash

/usr/local/tomcat/bin/catalina.sh stop -force
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to stop Tomcat Serive: $status"
  exit $status
fi
sleep 30
# Start the first process
/usr/local/tomcat/bin/catalina.sh start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Tomcat Serive: $status"
  exit $status
fi
# Start the second process
#/opt/appdynamics/machine-agent/bin/machine-agent 
#status=$?
#if [ $status -ne 0 ]; then
#  echo "Failed to start machine-agent: $status"
#  exit $status
#fi
while sleep 60; do
  ps aux |grep /usr/local/tomcat/bin/catalina.sh |grep -q -v grep
  PROCESS_1_STATUS=$?
#  ps aux |grep /opt/appdynamics/machine-agent/bin/machine-agent |grep -q -v grep
#  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
# if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done

