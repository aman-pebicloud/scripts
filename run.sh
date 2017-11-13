#!/bin/bash
START=$(date +%s.%N)

export oneteamrepo=/home/aman/data/oneteam
export cloudrepo=/home/aman/data/cloud

bin/setIp.sh && bin/stopPostgresql.sh && bin/startDockerImages.sh && bin/buildDistributions.sh 
echo "restarting scim and cas containers" 
sleep 5
echo "docker restart devapps1scim1; docker restart devapps1cas1" && docker restart devapps1scim1 && docker restart devapps1cas1
echo "copied tenant to clip board"
less bin/myTenant | xclip -sel clip
echo "go to self.wavity.net/doc"
xdg-open https://self.wavity.net/scim/doc &
END=$(date +%s.%N)
DIFF=$(echo "$END - $START")