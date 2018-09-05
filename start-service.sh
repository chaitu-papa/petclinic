#!/bin/bash

# Start the first process
./usr/local/tomcat/bin/catlina.sh start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Tomcat Serive: $status"
  exit $status
fi

# Start the second process
./opt/appdynamics/machine-agent/bin/machine-agent &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start machine-agent: $status"
  exit $status
fi

