#!/bin/bash
cd $cloudrepo/docker
echo "----starting docker images file----"
echo "docker-compose -f docker-compose-ub.yml up -d"
docker-compose -f docker-compose-ub.yml up -d
echo "docker-compose -f redis.yml up -d"
docker-compose -f redis.yml up -d
echo "docker-compose -f docker-compose-dev-oneteam.yml up -d"
docker-compose -f docker-compose-dev-oneteam.yml up -d
