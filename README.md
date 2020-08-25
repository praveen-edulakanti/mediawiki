Pre-requisites
Java, Jenkins, Packer, Terraform, aws cli should be installed.

AWS Access Key and Secret Access Key configure with below command:
aws configure

Adding Environment Variables for RDS mysql username and password with below command:
# Set secrets via environment variables
export TF_VAR_username=(username)
export TF_VAR_password=(password)


Create AMI with Packer Command:
packer build ./packer/packer-redhat-httpd-php.json

Terraform Commands:
terraform init
terraform plan -var-file="./env/MediaWiki-QA.tfvars" -out=MediaWiki-QAtfplanout
terraform apply MediaWiki-QAtfplanout

Using Jenkins Pipeline job complete Infrastructure will be created using file Jenkinsfile.

