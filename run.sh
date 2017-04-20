#!/bin/bash
export oneteamrepo=/home/aman/data/oneteam
export cloudrepo=/home/aman/data/cloud
export ip=192.168.2.66

bin/setIp.sh && bin/stopPostgresql.sh && bin/startDockerImages.sh && bin/buildDistributions.sh && echo "restarting scim and cas containers" && echo "docker restart devapps1scim1, docker restart devapps1cas1" && docker restart devapps1scim1 && docker restart devapps1cas1
