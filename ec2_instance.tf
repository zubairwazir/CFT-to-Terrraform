resource "aws_launch_configuration" "tomcat_launch_config" {
  name          = "TomcatLaunchConfig"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.tomcat_instance_profile.arn

  security_groups = [aws_security_group.tomcat_security_group.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
    #!/bin/bash -v
    yum -y update
    yum -y install awslogs
    systemctl start awslogsd
    systemctl enable awslogsd
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
    unzip awscliv2.zip
    /opt/aws/bin/cfn-init --verbose --stack ${aws_cloudformation_stack.current.name} --resource TomcatLaunchConfig --region ${var.aws_region}
    /opt/aws/bin/cfn-signal -e $? --stack ${aws_cloudformation_stack.current.name} --resource TomcatLaunchConfig --region ${var.aws_region}
  EOF
}
