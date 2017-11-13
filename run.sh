#!/bin/bash
START=$(date +%s.%N)

export oneteamrepo=/home/aman/data/oneteam
export cloudrepo=/home/aman/data/cloud

bin/setIp.sh && bin/stopPostgresql.sh && bin/buildStartDockerImages.sh && bin/buildDistributions.sh 

echo "restarting scim and cas containers" 
sleep 5
echo "docker restart devapps1scim1; docker restart devapps1cas1" && docker restart devapps1scim1 && docker restart devapps1cas1

END=$(date +%s.%N)
DIFF=$(echo "$END - $START")