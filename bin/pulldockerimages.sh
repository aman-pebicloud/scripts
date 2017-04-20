#!/bin/bash
cd $cloudrepo/docker ; echo "---docker pull wavity/wavity---"; docker pull wavity/wavity

echo "---sh wavity-docker.sh pull---"; ./wavity-docker.sh pull
