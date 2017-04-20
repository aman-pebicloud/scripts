#!/bin/bash

case $1 in
rmi)
for img in `docker images | grep ^wavity | awk '{ print $3 }'`
do
	docker rmi -f $img
done
for img in `docker images | grep ^\<none\> | awk '{ print $3 }'`
do
	docker rmi -f $img
done
;;
*)
echo "USAGE:$0 < rmi >"
;;
esac

# EOF

