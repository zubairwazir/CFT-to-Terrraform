resource "aws_autoscaling_group" "extracto_auto_scaling_group" {
  desired_capacity = var.desired_instances_per_az
  health_check_type = "EC2"
  launch_configuration = aws_autoscaling_notification.extracto_launch_config.group_names
  max_size = var.maximum_instances_per_az
  min_size = var.minimum_instances_per_az
  service_linked_role_arn = "arn:aws:iam::146637533799: role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling_Polaris"
  termination_policies = [
    "Closest ToNextInstanceHour",
    "OldestInstance",
    "Default"
  ]
  vpc_zone_identifier = [
    var.subnet1_id,
    var.subnet2_id
  ]
}

resource "aws_cloudwatch_metric_alarm" "extracto_cluster_resize_alarm" {
  alarm_name = "extracto_cluster_resize_alarm"
  alarm_actions = [
    aws_autoscaling_policy.extracto_scaling_policy.arn
  ]
  alarm_description = join("", [local.stack_name, " SQS extracto outbound translator message count gone up/down hence resizing the cluster"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = [
    {
      Name = "AutoscalingGroup"
      Value = aws_autoscaling_group.extracto_auto_scaling_group.id
    }
  ]
  evaluation_periods = "1"
  metric_name = join("", [local.stack_name, "-SQSMessageCount"])
  namespace = "ClusterResize"
  period = "300"
  statistic = "Minimum"
  threshold = "0"
}

resource "aws_autoscaling_notification" "extracto_launch_config" {
  group_names = [
        aws_autoscaling_group.extracto_auto_scaling_group.name
        ]
    topic_arn = "arn:aws:sns:us-east-1:146637533799:polaris-prod-asg-notifications"
    notifications = [
    {
      notification_types = [
        "autoscaling:EC2_INSTANCE_LAUNCH",
        "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
        "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
        "autoscaling:EC2_INSTANCE_TERMINATE"
      ]
    }
  ]
  // CF Property(AssociatePublic IpAddress) = false
  // CF Property(BlockDeviceMappings) = [
  //   {
  //     DeviceName = "/dev/sdc"
  //     VirtualName = "ephemeral0"
  //   },
  //   {
  //     DeviceName = "/dev/sdd"
  //     VirtualName = "ephemeral1"
  //   },
  //   {
  //     DeviceName = "/dev/sde"
  //     VirtualName = "ephemeral2"
  //   },
  //   {
  //     DeviceName = "/dev/sdf"
  //     VirtualName = "ephemeral3"
  //   },
  //   {
  //     DeviceName = "/dev/sdg"
  //     VirtualName = "ephemeral4"
  //   },
  //   {
  //     DeviceName = "/dev/sdh"
  //     VirtualName = "ephemeral5"
  //   },
  //   {
  //     DeviceName = "/dev/sdi"
  //     VirtualName = "ephemeral6"
  //   },
  //   {
  //     DeviceName = "/dev/sdj"
  //     VirtualName = "ephemeral7"
  //   },
  //   {
  //     DeviceName = "/dev/xvdm"
  //     Ebs = {
  //       DeleteOnTermination = "true"
  //       Encrypted = "true"
  //       Iops = 1000
  //       VolumeSize = "50"
  //       VolumeType = "gp2"
  //     }
  //   }
  // ]
  // CF Property(IamInstanceProfile) = var.instance_profile
  // CF Property(ImageId) = var.ami_id
  // CF Property(InstanceType) = var.instance_type
  // CF Property(KeyName) = local.UseKeyName ? var.key_name : null
  // CF Property(MetadataOptions) = {
  //   HttpEndpoint = "enabled"
  //   HttpTokens = "required"
  // }
  // CF Property(Placement Tenancy) = var.tenancy
  // CF Property(SecurityGroups) = [
  //   local.UseExtractoSecurityGroup ? aws_security_group.extracto_security_group[0].arn : var.security_group_id
  // ]
  // CF Property(UserData) = base64encode(join("", ["#!/bin/bash -v
  // ", "yum -y update
  // ", "yum -y install awslogs
  // ", "yum -y update
  // ", "cat > /etc/aws logs/aws logs.conf <<<EOF
  // ", "[general]
  // ", "state_file = /var/lib/awslogs/agent-state
  // ", "[var/log/]
  // ", "datetime_format = b %d %H:%M:%S
  // ", "file = ", "
  // ", "buffer_duration = 5000
  // ", "initial_position= start_of_file
  // ", "log_group_name = ", "
  // ", "log_stream_name = {instance_id}
  // ", "EOF
  // ", "systemctl start awslogsd
  // ", "systemctl enable awslogsd
  // ", "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip; unzip awscliv2.zip; ./awscli-exe-linux-x86_64/aws/install -i /usr/local", "TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 120")
  // ", "instance_id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
  // ", "az=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
  // ", "region=${az:0:${#az}-1}
  // ", "/opt/aws/bin/cfn-init -c Extracto --stack ", local.stack_id, "--resource ExtractoLaunchConfig", "--region", data.aws_region.current.name, "
  // ", "asg=$(aws ec2 describe-instances --region $region --instance-ids $instance_id --query 'Reservations []. Instances []. Tags [?key==`aws: cloud formation:login", "/opt/aws/bin/cfn-signal -e $? --stack", local.stack_id, "--resource $asg", "--region", data.aws_region.current.name, "
  // "]))
}


resource "aws_launch_configuration" "extracto_launch_config" {
  name_prefix   = "extracto-lc-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  associate_public_ip_address = false
  iam_instance_profile        = var.instance_profile
  key_name                    = local.UseKeyName ? var.key_name : null

  security_groups = [
    local.UseExtractoSecurityGroup ? aws_security_group.extracto_security_group[0].id : var.security_group_id
  ]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    stack_id                     = local.stack_id,
    stack_name                   = local.stack_name,
    cluster_name                 = var.cluster_name,
    az_quantity                  = var.az_quantity,
    minimum_instances_per_az     = var.minimum_instances_per_az,
    desired_instances_per_az     = var.desired_instances_per_az,
    maximum_instances_per_az     = var.maximum_instances_per_az,
    region                       = data.aws_region.current.name,
    start                        = var.start,
    pre_start_command            = var.pre_start_command,
    post_start_command           = var.post_start_command,
    encrypted_connections        = var.encrypted_connections,
    encrypted_storage_keyid      = var.encrypted_storage_key_id
    common_configuration         = var.common_configuration,
    truststore                   = var.truststore,
    truststore_password          = var.truststore_password,
    keystore                     = var.keystore,
    angelo_truststore            = var.angelo_truststore,
    angelo_truststore_password   = var.angelo_truststore_password,
    angelo_polaris_password      = var.angelo_polaris_password,
    prospero_truststore          = var.prospero_truststore,
    prospero_truststore_password = var.prospero_truststore_password,
    prospero_polaris_password    = var.prospero_polaris_password,
    prospero_cluster_name        = var.prospero_cluster_name,
    trend_policy_id              = var.trend_policy_id,
    trend_tenant_id              = var.trend_tenant_id,
    trend_tenant_password        = var.trend_tenant_password,
    angelo_ssl_url               = var.angelo_ssl_url,
    prospero_service_url         = var.prospero_service_url,
    environment                  = var.environment,
    bucket_name                  = var.bucket_name
  }))

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true
    iops                  = 1000
  }

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true
    iops                  = 1000
  }

  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdd"
    virtual_name = "ephemeral1"
  }

  ephemeral_block_device {
    device_name  = "/dev/sde"
    virtual_name = "ephemeral2"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdf"
    virtual_name = "ephemeral3"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdg"
    virtual_name = "ephemeral4"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdh"
    virtual_name = "ephemeral5"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdi"
    virtual_name = "ephemeral6"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdj"
    virtual_name = "ephemeral7"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "extracto_lifecycle_hook" {
  name                   = "extracto-lifecycle-hook"
  autoscaling_group_name = aws_autoscaling_group.extracto_auto_scaling_group.id
  default_result = "CONTINUE"
  heartbeat_timeout = 600
  lifecycle_transition = "autoscaling: EC2_INSTANCE_TERMINATING"
  notification_target_arn = aws_sns_topic.extracto_topic.id
  role_arn = "arn: aws: iam::146637533799: role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling_Polaris"
}

resource "aws_autoscaling_policy" "extracto_scaling_policy" {
  name = "ExtractoScalingPolicy"
  adjustment_type = "ExactCapacity"
  autoscaling_group_name = aws_autoscaling_group.extracto_auto_scaling_group.id
  estimated_instance_warmup = "120"
  metric_aggregation_type = "Average"
  policy_type = "StepScaling"
  step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 200
      scaling_adjustment          = 1
  }

  step_adjustment {
      metric_interval_lower_bound = 200
      scaling_adjustment          = 2
  }
}

resource "aws_security_group" "extracto_security_group" {
  count = local.UseExtractoSecurityGroup ? 1 : 0
  description = "Extracto stack security group"
  egress = [
    {
      cidr_blocks = "0.0.0.0/0"
      from_port = "0"
      protocol = "-1"
      to_port = "65535"
    }
  ]
  ingress = [
    {
      cidr_blocks = "10.0.0.0/8"
      from_port = "-1"
      protocol = "icmp"
      to_port = "-1"
    },
    {
      cidr_blocks = "10.0.0.0/8"
      from_port = "443"
      protocol = "tcp"
      to_port = "443"
    },
    {
      cidr_blocks = "10.0.0.0/8"
      from_port = "61616"
      protocol = "tcp"
      to_port = "61616"
    },
    {
      cidr_blocks = "10.0.0.0/8"
      from_port = "61617"
      protocol = "tcp"
      to_port = "61617"
    }
  ]
  vpc_id = var.vpc_id
}

resource "aws_cloudwatch_metric_alarm" "extracto_service_alarm" {
  alarm_name = "ExtractoClusterResizeAlarm"  
  alarm_actions = [
    var.alert_snsarn
  ]
  alarm_description = join("", [local.stack_name, "Service alarm for unhealthy host"])
  comparison_operator = "GreaterThanThreshold"
  dimensions = [
    {
      Name = "AutoscalingGroup"
      Value = "ExtractoAutoScalingGroup"
    }
  ]
  evaluation_periods = "1"
  metric_name = "ExtractoRunningCount"
  namespace = "ExtractoService"
  period = "300"
  statistic = "Minimum"
  threshold = "0"
}

resource "aws_sns_topic" "extracto_topic" {
  kms_master_key_id = "d82fa3dc-2168-4d9e-b2cb-5c5e3b45d935"
  // CF Property(Subscription) = [
  //   {
  //     Endpoint = var.sqsa_sg_alert1a
  //     Protocol = "sqs"
  //   },
  //   {
  //     Endpoint = var.sqsa_sg_alert1b
  //     Protocol = "sqs"
  //   }
  // ]
  name = local.stack_name
  tags = {
    Billing = "DataSolutions/Polaris"
    APP_ID = "842"
    COST_CENTER = "40139"
  }
}

