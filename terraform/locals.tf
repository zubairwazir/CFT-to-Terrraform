locals {
  InputInstanceProfileIsEmpty = var.instance_profile == ""
  IsRegionEast = data.aws_region.current.name == "us-east-1"
  UseAsg2 = anytrue([var.az_quantity == "2", var.az_quantity == "3"])
  UseAsg3 = var.az_quantity == "3"
  UseAsg4 = var.az_quantity == "4"
  UseCustomAmiId = !var.ami_id == ""
  UseExtractoIAMRole = var.iam_role_name == ""
  UseExtractoSecurityGroup = var.security_group_id == ""
  UseKeyName = !var.key_name == ""
  stack_name = "Polaris-Production-Extracto-Era"
  stack_id = uuidv5("dns", "Polaris-Production-Extracto-Era")
}

