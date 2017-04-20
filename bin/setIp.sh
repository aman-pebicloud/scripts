#!/bin/bash
echo "----Setting IP--- to $ip"
sudo ifconfig eth0 $ip netmask 255.255.255.0
