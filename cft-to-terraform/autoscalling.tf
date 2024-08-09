resource "aws_autoscaling_group" "tomcat_asg" {
  launch_configuration = aws_launch_configuration.tomcat_launch_config.id
  min_size             = var.min_instances_per_az
  desired_capacity     = var.desired_instances_per_az
  max_size             = var.max_instances_per_az
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = var.name_tag
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  health_check_type = "EC2"

  wait_for_capacity_timeout = "0"
}
