# ensure required number of arguments are passed
if [ $# -ne 2 ]; then 
   echo "you have passed wrong arguments"
   echo "desired format is= $0 <region> <action>"
   exit 1
fi

REGION="$1"
action="$2"



if [ "$action" != "create" ] && [ "$action" != "delete" ];  then
   echo "presently it supports only create and delete actions"
   exit 1
fi

if [ "$action" == "create" ];then 

  ### create vpc
  vpc_id=$(aws ec2 create-vpc --cidr-block "198.168.0.0/16" \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=shahinur},\
  {Key=Createdby,Value=cli}]" \
  --query Vpc.VpcId --output text --region "$REGION")
  echo "Vpc_Id=$vpc_id" 


  ### create subnet app1
  subnet_app1=$(aws ec2 create-subnet --tag-specifications \
   "ResourceType=subnet,Tags=[{Key=Name,Value=app1},\
   {Key=Createdby,Value=cli}]" --vpc-id "$vpc_id"\
    --cidr-block "198.168.0.0/24" --availability-zone "${REGION}a"\
    --output text --query "Subnet.SubnetId")

    echo "app1_SubnetId=$subnet_app1"


  ### create subnet app2
  subnet_app2=$(aws ec2 create-subnet --tag-specifications \
  "ResourceType=subnet,Tags=[{Key=Name,Value=app2},{Key=Createdby,Value=cli}]" \
  --vpc-id "$vpc_id" --cidr-block "198.168.1.0/24" \
  --availability-zone "${REGION}b" --output text --query "Subnet.SubnetId")

  echo "app2_SubnetId=$subnet_app2"

  ### create subnet db1
  subnet_db1=$(aws ec2 create-subnet --tag-specifications \
  "ResourceType=subnet,Tags=[{Key=Name,Value=db1},{Key=Createdby,Value=cli}]" \
  --vpc-id "$vpc_id" --cidr-block "198.168.2.0/24" \
  --availability-zone "${REGION}a" --output text --query "Subnet.SubnetId")

  echo "db1_SubnetId=$subnet_db1"

  ### create subnet db2
  subnet_db2=$(aws ec2 create-subnet --tag-specifications \
  "ResourceType=subnet,Tags=[{Key=Name,Value=db2},{Key=Createdby,Value=cli}]" \
  --vpc-id "$vpc_id" --cidr-block "198.168.3.0/24" \
  --availability-zone "${REGION}b" --output text --query "Subnet.SubnetId")

  echo "db2_SubnetId=$subnet_db2"
elif [ "$action" == "delete" ]; then
### find all the subnet ids

subnets=$(aws ec2 describe-subnets \
 --filters "Name=tag:Createdby, Values=cli" \
 --query "Subnets[].SubnetId" --output text --region "${REGION}")
 for subnet in $subnets; do
 aws ec2 delete-subnet --subnet-id "$subnet"
 echo "deleted subnet $subnet"
 done
 ## find vpc ids
 vpcs=$(aws ec2 describe-vpcs --filters \
"Name=tag:Createdby, Values=cli" \
--query Vpcs[].VpcId --output text --region "${REGION}")
### delete vpcs
for vpc in $vpcs; do
aws ec2 delete-vpc --vpc-id "$vpc"
echo "deleted vpc $vpc"
done
fi
