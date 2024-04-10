#!/bin/bash
if [ "$#" -ne 3 ]; then
   echo "usage $0 <action> <tagName> <tagValue>"
   exit 1
else
   action=$1
   tagName=$2
   tagValue=$3
fi
### find all the valid region in aws 

regions=$(aws ec2 describe-regions \
 --query "Regions[].RegionName" --output text)
 for region in $regions; do
 echo "checking region $region"

 ### find all instance ids of ec2 instances
 instance_ids=$(aws ec2 describe-instances --region $region \
      --filters "Name=tag:${tagName},Values=${tagValue}" \
         "Name=instance-state-name,Values=running,stopped" \
      --query "Reservations[].Instances[].InstanceId" \
       --output text)
      if [[ ! -z "$instance_ids" ]]; then
         echo "Actopm $action will performed on:${instance_ids}"
          if [[ $action == stop ]]; then
                for instance in $instance_ids; do
                aws ec2 stop-instances --instance-ids "$instance" > /dev/null
                echo "stopped instance with id= $instance"
                done
            elif [[ $action == start ]]; then
                for instance in $instance_ids; do
                aws ec2 start-instances --instance-ids "$instance" > /dev/null
                echo "started instance with id= $instance"
                done   
            elif [[ $action == terminate ]]; then
                 for instance in $instance_ids; do
                aws ec2 terminate-instances --instance-ids "$instance" > /dev/null
                echo "terminated instance with id= $instance"
                done
            fi
      else
         echo "no instances found with $tagName=$tagValue"
      fi
done