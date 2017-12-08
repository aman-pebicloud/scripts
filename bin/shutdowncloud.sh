#!/bin/bash
cd $cloudrepo/docker; docker-compose -f redis.yml down; docker-compose -f docker-compose-dev-oneteam.yml down; docker-compose -f docker-compose-ub.yml down --remove-orphans
