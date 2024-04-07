REGION="ap-south-1"

### create vpc
vpc_id=$(aws ec2 create-vpc --cidr-block "198.168.0.0/16" \
--tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=shahinur},\
{Key=Createdby,Value=cli}]" \
--query Vpc.VpcId --output text --region $REGION)
echo "Vpc_Id=$vpc_id" 


### create subnet app1
subnet_app1=$(aws ec2 create-subnet --tag-specifications\
 "ResourceType=subnet,Tags=[{Key=Name,Value=app1},\
 {Key=Createdby,Value=cli}]" --vpc-id "$vpc_id"\
  --cidr-block "198.168.0.0/24" --availability-zone "$REGIONa"\
  --output text --query "Subnet.SubnetId")

  echo "app1_SubnetId = $subnet_app1"


### create subnet app2
subnet_app2=$(aws ec2 create-subnet --tag-specifications \
"ResourceType=subnet,Tags=[{Key=Name,Value=app2},{Key=Createdby,Value=cli}]" \
--vpc-id "$vpc_id" --cidr-block "198.168.1.0/24" \
--availability-zone "$REGIONb" --output json --query "Subnet.SubnetId")

echo "app2_Subnet_Id=$subnet_app2"

### create subnet db1
subnet_db1=$(aws ec2 create-subnet --tag-specifications \
"ResourceType=subnet,Tags=[{Key=Name,Value=db1},{Key=Createdby,Value=cli}]" \
--vpc-id "$vpc_id" --cidr-block "198.168.2.0/24" \
--availability-zone "$REGIONa" --output text --query "Subnet.SubnetId")

echo "db1_SubnetId=$subnet_db1"



### create subnet db2
subnet_db2=$(aws ec2 create-subnet --tag-specifications \
"ResourceType=subnet,Tags=[{Key=Name,Value=db2},{Key=Createdby,Value=cli}]" \
--vpc-id "$vpc_id" --cidr-block "198.168.3.0/24" \
--availability-zone "$REGIONb" --output text --query "Subnet.SubnetId")

echo "db2_subnetId=$subnet_db2"
