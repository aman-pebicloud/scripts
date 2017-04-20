#!/bin/bash
cd $cloudrepo/docker
echo "----building and starting docker images using docker-compose-ub.yml file----"
echo "docker-compose -f docker-compose-ub.yml build; docker-compose -f docker-compose-ub.yml up -d"
docker-compose -f docker-compose-ub.yml build
docker-compose -f docker-compose-ub.yml up -d
echo "----building and starting docker images using docker-compose-dev-oneteam.yml file----"
echo "docker-compose -f docker-compose-dev-oneteam.yml build; docker-compose -f docker-compose-dev-oneteam.yml up -d"
docker-compose -f docker-compose-dev-oneteam.yml build
docker-compose -f docker-compose-dev-oneteam.yml up -d

