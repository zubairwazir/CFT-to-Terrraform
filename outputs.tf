output "ec2_instance_role_arn" {
  description = "ARN of the IAM role associated with the EC2 instance"
  value       = aws_iam_role.ec2_instance_role.arn
}

output "security_group_id" {
  description = "ID of the Tomcat Security Group"
  value       = aws_security_group.tomcat_security_group.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.tomcat_asg.name
}
