#!/bin/bash

### find all the valid regions in AWS
regions=$(aws ec2 describe-regions --query \
 Regions[].RegionName --output text)

### find all instance IDs of EC2 instances
instance_ids=$(aws ec2 describe-instances \
    --region "us-east-1" \
    --filters "Name=tag:Env,Values=Dev" \
    --query Reservations[].Instances[].InstanceId --output text)

for instance in $instance_ids; do
    aws ec2 stop-instances --instance-ids "$instance /dev/null"
    echo "Deleted instance with ID: $instance"
done
