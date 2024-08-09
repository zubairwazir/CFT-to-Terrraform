variable "aws_region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID to use for the base image."
  type        = string
  default     = "ami-0809712cd2427ab4d"
}

variable "instance_type" {
  description = "EC2 instance type for the cluster."
  type        = string
  default     = "c3.4xlarge"
}

variable "az_quantity" {
  description = "Number of availability zones to deploy into (1, 2, or 3)."
  type        = number
  default     = 2
}

variable "min_instances_per_az" {
  description = "Minimum instances per availability zone."
  type        = number
  default     = 1
}

variable "desired_instances_per_az" {
  description = "Desired number of instances per availability zone."
  type        = number
  default     = 1
}

variable "max_instances_per_az" {
  description = "Maximum number of instances per availability zone."
  type        = number
  default     = 1
}

variable "key_name" {
  description = "EC2 key pair for SSH access."
  type        = string
  default     = "Polaris_PROD_ALL"
}

variable "name_tag" {
  description = "Name resource tag."
  type        = string
  default     = "Polaris-Production-20240415-Tomcat"
}

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
  default     = "20240415"
}

variable "alert_sns_arn" {
  description = "ARN to send SNS alerts."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
  default     = "polaris-che-prod-datasolutions"
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs."
  type        = list(string)
}
