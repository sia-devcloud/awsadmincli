#! bin/bash

#create vpc

aws ec2 create-vpc --cidr-block "198.168.0.0/16" --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=shahinur},{Key=Createdby,Value=cli}]"