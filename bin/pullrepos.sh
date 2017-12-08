#!/bin/bash
echo "---pulling oneteam changes---"
cd $oneteamrepo ; git checkout develop; git pull

echo "---pulling cloud changes---"
cd $cloudrepo ; git checkout develop; git pull
