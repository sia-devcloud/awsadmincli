#!/bin/bash


### find all the valid region in aws 

regions=$(aws ec2 describe-regions \
 --query "Regions[].RegionName" --output text)

 ### find all instance ids of ec2 instances

 instance_ids=$(aws ec2 describe-instances --region "us-east-1" \
  --filters "Name=tag:Env,Values=Dev" \
   "Name=instance-state-name,Values=running,stopped)" \
  --query "Reservations[].Instances[].InstanceId" --output text)

for instance in $instance_ids; do
aws ec2 terminate-instances --instance-ids "$instance >/dev/null"
echo "deleted instance with id= "$instance""
done