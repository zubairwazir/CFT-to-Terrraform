resource "aws_iam_role" "ec2_instance_role" {
  name               = "TomcatEC2Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  inline_policy {
    name   = "TomcatPolicy"
    policy = data.aws_iam_policy_document.tomcat_policy.json
  }
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "tomcat_policy" {
  statement {
    actions   = ["kms:GenerateDataKey", "s3:GetObject", "s3:List*"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}
