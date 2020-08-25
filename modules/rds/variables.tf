variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "private_subnetID" {
	type  = list
}

variable "PrivateSecurityGrpID" {
    type = string
}

variable "RdsDatabase" {
   type = map
}

variable "username" {
  description = "The username for the DB master user"
  type        = string
}

variable "password" {
  description = "The password for the DB master user"
  type        = string
}
