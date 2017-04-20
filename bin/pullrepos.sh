#!/bin/bash
echo "---pulling oneteam changes---"
cd $oneteamrepo ; git checkout master; git pull

echo "---pulling cloud changes---"
cd $cloudrepo ; git checkout master; git pull
