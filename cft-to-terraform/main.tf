# Load variables from variables.tf
variable "aws_region" {}
variable "ami_id" {}
variable "instance_type" {}
variable "az_quantity" {}
variable "min_instances_per_az" {}
variable "desired_instances_per_az" {}
variable "max_instances_per_az" {}
variable "key_name" {}
variable "name_tag" {}
variable "cluster_name" {}
variable "alert_sns_arn" {}
variable "bucket_name" {}
variable "vpc_id" {}
variable "subnet_ids" {}

# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Include other configuration files
module "iam_roles" {
  source = "./iam_roles.tf"
}

module "security_group" {
  source = "./security_group.tf"
}

module "ec2_instance" {
  source = "./ec2_instance.tf"
}

module "autoscaling" {
  source = "./autoscaling.tf"
}

# Output values from outputs.tf
output "ec2_instance_role_arn" {
  value = module.iam_roles.ec2_instance_role_arn
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "asg_name" {
  value = module.autoscaling.asg_name
}
