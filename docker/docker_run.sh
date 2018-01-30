#!/bin/sh

usage() {
  echo "Usage:"
  echo "\tProvide start and end port range for chromedriver"
  echo "\tExample: $0 9810 9820\n"
} 

if [  $# -le 1 ] 
then
  usage
  exit 1
fi

PORT="-p 8080:8080"
VOLUME="-v /dev/shm:/dev/shm --volumes-from jenkinsdata"
CONTAINER_NAME="--name jenkins"
IMAGE_NAME="jenkins/watir"
JENKINS_HOME="/var/jenkins_home"
CHROMEDRIVER_CMD="/usr/local/bin/chromedriver"

CHROMEDRIVER_START_PORT=${1}
CHROMEDRIVER_END_PORT=${2}

CONTAINER_ID=$(docker run -d -u jenkins $PORT $CONTAINER_NAME $IMAGE_NAME $COMMANDS)

# COMMANDS="$CHROMEDRIVER_CMD --port=$CHROMEDRIVER_START_PORT &"

for port in $(seq $CHROMEDRIVER_START_PORT $CHROMEDRIVER_END_PORT); do
  docker exec -d $CONTAINER_ID $CHROMEDRIVER_CMD --port=$port  
done

echo $CONTAINER_ID