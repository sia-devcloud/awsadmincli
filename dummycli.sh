#!/bin/bash

if [ $# -ne 2 ]; then
echo "you have passed wrong input"
echo "format <region> <action>"
exit 1
fi

#print all the arguments
echo "arguments passed: $@"
region=$1
action=$2

echo "you want $region and I want $action"