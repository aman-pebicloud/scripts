#!/bin/bash
cd $cloudrepo/docker
echo "----starting docker images using docker-compose-ub.yml file----"
echo "docker-compose -f docker-compose-ub.yml up -d"
docker-compose -f docker-compose-ub.yml up -d
echo "----starting docker images using docker-compose-dev-oneteam.yml file----"
echo "docker-compose -f docker-compose-dev-oneteam.yml up -d"
docker-compose -f docker-compose-dev-oneteam.yml up -d