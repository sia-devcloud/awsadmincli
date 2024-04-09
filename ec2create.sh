#!/bin/bash

# Define variables
ami_id="ami-080e1f13689e07408"
instance_type="t2.micro"
###key_name="your_key_pair_name"
###security_group_id="your_security_group_id"
###subnet_id="your_subnet_id"
count=4  # Number of instances to launch
region="us-east-1"

# Launch instances
aws ec2 run-instances \
    --image-id "$ami_id" \
    --instance-type "$instance_type" \
    --count $count \
    --region "$region" \
    --query "Reservations[].Instances[].InstanceId" --output text
    #--tag-specifications \
     #"ResourceType=instance,\
     #Tags=[{Key=Env,Value=Dev}]" \ 
