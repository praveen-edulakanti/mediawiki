region      = "ap-south-1"
environment = "Staging"
aws_profile = "default"
project     = "DemoProject"
ansible_host_label = "WebServer"

vpc = {
  name       = "VPC"
  cidr_block = "10.101.0.0/16"
}
#Internet Gateway
igw_name = "IGW"

#Elastic IP Address
EIPs = [
  {
    name = "EIP1a"
  },
  {
    name = "EIP1b"
  }
]

#NAT Gateway
NATGateways = [
  {
    name = "NATGateway1a"
  },
  {
    name = "NATGateway1b"
  }
]

public_subnets = [
  {
    name              = "PublicSubnet1a"
    cidr_block        = "10.101.1.0/24"
    availability_zone = "ap-south-1a"
    #map_public_ip_on_launch = true
  },
  {
    name              = "PublicSubnet1b"
    cidr_block        = "10.101.2.0/24"
    availability_zone = "ap-south-1b"
    #map_public_ip_on_launch = true
  }
]

private_subnets = [
  {
    name                    = "PrivateSubnet1a"
    cidr_block              = "10.101.3.0/24"
    availability_zone       = "ap-south-1a"
    map_public_ip_on_launch = false
  },
  {
    name                    = "PrivateSubnet1b"
    cidr_block              = "10.101.4.0/24"
    availability_zone       = "ap-south-1b"
    map_public_ip_on_launch = false
  }
]

private_subnet_route_tables = [
  {
    name = "PrivateSubnetRT1"
  },
  {
    name = "PrivateSubnetRT2"
  }
]

public_subnet_route_tables = [
  {
    name = "PublicRT"
  }
]

PublicSecurityGrp_egress = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

PrivateSecurityGrp_egress = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]


PublicInstances = [
  {
    name                        = "MediaWikiWebServer"
    #ami                         = "ami-052c08d70def0ac62" #Red Hat Enterprise Linux 8 (HVM)
    ami_name                    = "Packer_RedHathttpdPhp"
    availability_zone           = "ap-south-1a"
    instance_type               = "t2.micro"
    key_name                    = "terraform-demo"
    associate_public_ip_address = true
  },
  {
    name                        = "MediaWikiDBServer"
    ami                         = "ami-052c08d70def0ac62" #Red Hat Enterprise Linux 8 (HVM)
    availability_zone           = "ap-south-1b"
    instance_type               = "t2.micro"
    key_name                    = "terraform-demo"
    associate_public_ip_address = true
    user_data                  = "./modules/user-data/user-data-mysql.sh"
  }
]

PrivateInstances = [
  {
    name                        = "AWSWEBPri1a"
    ami_name                    = "Packer_RedHathttpdPhp"
    availability_zone           = "ap-south-1a"
    instance_type               = "t2.micro"
    key_name                    = "terraform-demo"
    associate_public_ip_address = false
  },
  {
    name                        = "AWSWEBPri1b"
    ami_name                    = "Packer_RedHathttpdPhp"
    availability_zone           = "ap-south-1b"
    instance_type               = "t2.micro"
    key_name                    = "terraform-demo"
    associate_public_ip_address = false
  }
]

LoadBalancerName = "LoadBalancer-Staging"

TargetGroupNames = [
  {
    name = "Target-1"
  },
  {
    name = "Target-2"
  }
]

AlbForwardRules = [
	{
		  name = "rule-1"
		  priority  = 90
		  type = "forward"
		  field = "path-pattern"
		  values = "/index.php"
	},
	{
		  name = "rule-2"
		  priority  = 100
		  type = "forward"
		  field = "path-pattern"
		  values = "/index.php"
	}
]

Route53zone_id   = "Z03184512L9I1FKCYWYON"

DomainAliases = [
  {
    DomainName = "mediawiki-staging.edulakanti.info"
  }/*,
  {
    DomainName = "www.edulakanti.info"
  }*/
]

dbDetails = {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wikidatabase"
  username             = ""
  password             = ""
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  =  "true"
  deletion_protection  =  "false"
 }
