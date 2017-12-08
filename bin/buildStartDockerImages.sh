#!/bin/bash
cd $cloudrepo/docker
echo "---building and starting docker images ---"
echo "docker-compose -f docker-compose-ub.yml build"
echo "docker-compose -f docker-compose-ub.yml up -d"
echo "docker-compose -f redis.yml up -d"
docker-compose -f docker-compose-ub.yml build
docker-compose -f docker-compose-ub.yml up -d
docker-compose -f redis.yml up -d
echo "docker-compose -f docker-compose-dev-oneteam.yml build"
echo "docker-compose -f docker-compose-dev-oneteam.yml up -d"
docker-compose -f docker-compose-dev-oneteam.yml build
docker-compose -f docker-compose-dev-oneteam.yml up -d
