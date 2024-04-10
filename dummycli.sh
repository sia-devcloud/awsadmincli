#!/bin/bash

tagName="Env"
tagValue="Dev"
### find all the valid region in aws 

regions=$(aws ec2 describe-regions \
 --query "Regions[].RegionName" --output text)
 for region in $regions; do
 echo "checking region "$region""

 ### find all instance ids of ec2 instances

      instance_ids=$(aws ec2 describe-instances --region "$region" \
      --filters "Name=tag:${tagName},Values=${tagValue}" \
         "Name=instance-state-name,Values=running,stopped)" \
      --query "Reservations[].Instances[].InstanceId" --output text \
       --region $region)

       if [[ $instance_ids != None ]]; then
       echo "Following instances will be stopped: $instance_ids"

      for instance in $instance_ids; do
      aws ec2 terminate-instances --instance-ids "$instance" >/dev/null
      echo "deleted instance with id= "$instance""
      done
      else
      echo "no instance"
done