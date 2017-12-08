#!/bin/bash
bin/setIp.sh
bin/stopPostgresql.sh
bin/buildStartDockerImages.sh
bin/buildDistributions.sh

echo "restarting scim and cas containers"
sleep 5
echo "docker restart devapps1scim1; docker restart devapps1cas1"
docker restart devapps1scim1 && docker restart devapps1cas1
bin/copyTenantInfo.sh
echo "go to self.wavity.net/doc"
xdg-open https://self.wavity.net/scim/doc &
