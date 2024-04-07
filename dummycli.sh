#!/bin/bash


vpcs=$(aws ec2 describe-vpcs --filters \
"Name=tag:Createdby, Values=cli" \
--query Vpcs[].VpcId --output text)
for vpc in $vpcs; do
aws ec2 delete-vpc --vpc-id "$vpc"
echo "deleted vpc $vpc"
done





















#subnets=$(aws ec2 describe-subnets \
 #--filters "Name=tag:Createdby, Values=cli" \
 #--query "Subnets[].SubnetId" --output text)
 #for subnet in $subnets; do
 #aws ec2 delete-subnet --subnet-id "$subnet"
 #echo "deleted subnet $subnet"
 #done