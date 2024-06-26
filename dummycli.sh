#!/bin/bash
if [ "$#" -ne 2 ]; then
   echo "usage $0 <tagName> <tagValue>"
   exit 1
else
   tagName=$1
   tagValue=$2
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
        echo "Following instances will be stopped:${instance_ids}"
        for instance in $instance_ids; do
        aws ec2 stop-instances --instance-ids "$instance" > /dev/null
        echo "stopped instance with id= $instance"
        done
      else
         echo "no instances found with $tagName=$tagValue"
      fi
done