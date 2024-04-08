#!/bin/bash


### find all the valid region in aws 

regions=$(aws ec2 describe-regions 
 --query Regions[].RegionName --output text)


 ### find all instance ids of ec2 instances

 instance_ids=$(aws ec2 describe-instances \
  --region "us-east-1" \
   --filters "Name=tag:Env ,Values=Dev" \
   --query Reservations[].Instances[].InstanceId --output text)

for instance in $instance_ids; do
aws ec2 terminate-instances --instance-ids \
"$instance"
echo "deleted instance with id= "$instance""
done





















#subnets=$(aws ec2 describe-subnets \
 #--filters "Name=tag:Createdby, Values=cli" \
 #--query "Subnets[].SubnetId" --output text)
 #for subnet in $subnets; do
 #aws ec2 delete-subnet --subnet-id "$subnet"
 #echo "deleted subnet $subnet"
 #done