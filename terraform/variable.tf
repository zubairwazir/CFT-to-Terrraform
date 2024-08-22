variable ami_id {
  description = "The SSM AMI to use"
  type = string
  default = "/nimbus/gold/linux/amazon-2"
}

variable az_quantity {
  description = "Number of availability zones to deploy into (1, 2 or 3)."
  type = string
  default = "1"
}

variable alert_snsarn {
  description = "ARN of SNS for notification"
  type = string
  default = "arn: aws: sns: us-east-1:442119052822:MonitoringEventsCommon"
}

variable angelo_polaris_password {
  description = "AngeloPolaris Password password."
  type = string
}

variable angelo_ssl_url {
  description = "Angelo ssl url."
  type = string
}

variable angelo_truststore {
  description = "53 location 'bucket/.../keystore' to JKS keystore for encrypting connections to the Angelo"
  type = string
  default = "*"
}

variable angelo_truststore_password {
  description = "AngeloTruststorePassword password."
  type = string
}

variable bucket_name {
  description = "BucketName."
  type = string
  default = "polaris-chc-prod-datasolutions"
}

variable cluster_name {
  description = "Name of cluster"
  type = string
  default = "20240416"
}

variable common_configuration {
  description = "53 location 'bucket/.../config' to an object that declares cluster(s) and consumer(s) for all nodes in the cluster."
  type = string
}

variable desired_instances_per_az {
  description = "Desired number of instances for each availability zone."
  type = string
  default = "1"
}

variable encrypted_connections {
  description = "Encrypt all connections? 'true' or 'false'"
  type = string
  default = "true"
}

variable encrypted_storage_key_id {
  description = "KMS Key Id for encrypted storage (if empty storage is not encrypted)."
  type = string
}

variable environment {
  description = "Environment designator, 'dev' or 'prod'."
  type = string
  default = "prod"
}

variable iam_role_name {
  description = "Custom / production IAM role (if empty the DEV-EC2-Role will be used which has full privs)."
  type = string
  default = "Polaris-Radagast"
}

variable instance_profile {
  description = "Optional: If provided, it will be used; else a new InstanceProfile for the IAM Role will be created."
  type = string
  default = "Polaris-Radagast"
}

variable instance_type {
  description = "EC2 instance type for cluster."
  type = string
  default = "c5.4xlarge"
}

variable key_name {
  description = "EC2 key pair for ssh access to instances"
  type = string
  default = "Polaris_PROD_ALL"
}

variable keystore {
  description = "53 location 'bucket/.../keystore' to JKS keystore for encrypting connections to the Reddo cluster."
  type = string
  default = "polaris-chc-prod-datasolutions/emdeon-polaris-production-7526-us-east-1/extracto/ssl/extracto.keystore"
}

variable keystore_password {
  description = "Keystore password."
  type = string
  default = "1NucQo900PpqEnS"
}

variable maximum_instances_per_az {
  description = "Maximum number of instances for each availability zone."
  type = string
  default = "2"
}

variable minimum_instances_per_az {
  description = "Minimum of instances for each availability zone."
  type = string
  default = "1"
}

variable name_tag {
  description = "Name resource tag"
  type = string
  default = "Polaris-Production-20240415-Extracto-Era"
}

variable post_start_command {
  description = "Command to run after services are started"
  type = string
}

variable pre_start_command {
  description = "Command to run before services are started"
  type = string
}

variable prospero_cluster_name {
  description = "ProsperoClustername for the current stack."
  type = string
}

variable prospero_polaris_password {
  description = "ProsperoPolaris Password password."
  type = string
  default = "N1zPlaKTtFBlivK"
}

variable prospero_service_url {
  description = "Prospero service Url"
  type = string
  default = "https://internal-Polaris-P-Prospero-1MMC0A26E4L7-1142668064.us-east-1.elb.amazonaws.com:8443/prospero"
}

variable prospero_truststore {
  description = "53 location 'bucket/.../keystore' to JKS keystore for encrypting connections to the Prospero"
  type = string
  default = "polaris-chc-prod-datasolutions/emdeon-polaris-production-7526-us-east-1/prospero/ssl/prospero.truststore"
}

variable prospero_truststore_password {
  description = "ProsperoTruststorePassword password."
  type = string
  default = "KnbEgd0NY6ZID7t"
}

variable sqsa_sg_alert1a {
  description = "Queue to send alert messages to upload logs for az - 1a"
  type = string
  default = "arn:aws: sqs:us-east-1:146637533799: polaris-log-uploader-Era-prod-Extracto-1a"
}

variable sqsa_sg_alert1b {
  description = "Queue to send alert messages to upload logs for az - 1b"
  type = string
  default = "arn: aws: sqs:us-east-1:146637533799: polaris-log-uploader-Era-prod-Extracto-1b"
}

variable security_group_id {
  description = "Custom / production security group (if empty all ports will be open to everywhere)."
  type = string
}

variable start {
  description = "Start services when install is complete? 'true' or 'false'"
  type = string
  default = "true"
}

variable subnet1_id {
  description = "First subnet to deploy into (required)."
  type = string
  default = "subnet-8ee648c7"
}

variable subnet2_id {
  description = "Second subnet to deploy into (required if AZQuantity = 2 or 3)."
  type = string
  default = "subnet-4db54816"
}

variable subnet3_id {
  description = "Third subnet to deploy into (required if AZQuantity = 3)."
  type = string
  default = "subnet-aa3ac587"
}

variable subnet4_id {
  description = "Third subnet to deploy into (required if AZQuantity = 4)."
  type = string
  default = "*"
}

variable tenancy {
  description = "EC2 tenancy type ('default' or 'dedicated')"
  type = string
  default = "default"
}

variable trend_policy_id {
  description = "Policy ID to activate for Trend Deep Security."
  type = string
  default = "741"
}

variable trend_tenant_id {
  description = "Tenant ID for Trend Deep Security."
  type = string
  default = "831A0C94-869E-79E6-1AE3-114A69544CC8"
}

variable trend_tenant_password {
  description = "Tenant password for Trend Deep Security."
  type = string
  default = "418874C4-E21F-7466-85AE-CAB64DE3E20E"
}

variable truststore {
  description = "53 location 'bucket/.../truststore' to JKS truststore for connections to Merlin (Cassandra) and Angelo (ActiveMQ)."
  type = string
  default = "polaris-chc-prod-datasolutions/emdeon-polaris-production-7526-us-east-1/extracto/ssl/extracto.truststore"
}

variable truststore_password {
  description = "Truststore password."
  type = string
  default = "KnbEgd0NY6ZID7t"
}

variable vpc_id {
  description = "VPC Id to deploy into."
  type = string
  default = "vpc-6977590e"
}

