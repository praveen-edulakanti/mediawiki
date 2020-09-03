resource "aws_instance" "PublicInstance" {
	count = length(var.PublicInstances)
	 #ami = lookup(var.PublicInstances[count.index], "ami")
	 ami = data.aws_ami.latest-redhat8.id
	 availability_zone = lookup(var.PublicInstances[count.index], "availability_zone")
	 instance_type = lookup(var.PublicInstances[count.index], "instance_type")
	 key_name = lookup(var.PublicInstances[count.index], "key_name")
	 subnet_id = var.public_subnetID[count.index]
	 associate_public_ip_address = lookup(var.PublicInstances[count.index], "associate_public_ip_address")
	 user_data = file(lookup(var.PublicInstances[count.index], "user_data"))
	 vpc_security_group_ids = [var.PublicSecurityGrpID]
	 
	tags = {
		Name = format("${var.environment}-%s", lookup(var.PublicInstances[count.index], "name"))
		Environment = var.environment
        Project = var.project
	    Terraformed = "True"
	}
}

resource "aws_instance" "PrivateInstance" {
	 count = length(var.PrivateInstances)
	 ami = data.aws_ami.latest-redhat8.id
	 availability_zone = lookup(var.PrivateInstances[count.index], "availability_zone")
	 instance_type = lookup(var.PrivateInstances[count.index], "instance_type")
	 key_name = lookup(var.PrivateInstances[count.index], "key_name")
	 subnet_id = var.private_subnetID[count.index]
	 associate_public_ip_address = lookup(var.PrivateInstances[count.index], "associate_public_ip_address")
	 vpc_security_group_ids = [var.PrivateSecurityGrpID]

	#Copies the LocalSettings.php file to /var/www/mediawiki/LocalSettings.php
	/*provisioner "file" {
		source      = "./env/QA/config/LocalSettings.php"
		destination = "/var/www/mediawiki/LocalSettings.php"

	connection {
    	type = "ssh"
    	user = "ec2-user"
    	host = "${element(aws_instance.PrivateInstance.*.private_ip, count.index)}"
    	#private_key = file("~/.ssh/terraform-demo.pem")
		private_key = file("C://Users//pedulakanti//Downloads//terraform-demo.pem")
     }
	} */

	tags = {
		Name = format("${var.environment}-%s", lookup(var.PrivateInstances[count.index], "name"))
		Environment = var.environment
        Project = var.project
	    Terraformed = "True"
	}
}

data "aws_ami" "latest-redhat8" {
 most_recent = true
 owners = ["863896359115"] # Canonical

  filter {
      name   = "name"
      values = ["Packer_RedHathttpdPhp *"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

resource "null_resource" "ConfigureAnsibleLabelVariable" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    #command = "echo [${var.ansible_host_label}] >> hosts"
	command = "echo [WebServer] > hosts"
  }
}

resource "null_resource" "ProvisionRemoteHostsIpToAnsibleHosts" {
	
	count = length(var.PrivateInstances)
	triggers = {
     always_run = "${timestamp()} + count.index"
    }
	
	provisioner "local-exec" {
       command = "echo ${element(aws_instance.PrivateInstance.*.private_ip, count.index)} >> hosts"
	   on_failure = continue
    }
}
