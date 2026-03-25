variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_name" {
  description = "Name used to tag and identify resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications (SNS)"
  type        = string
  default     = ""
}

variable "rds_db_name" {
  description = "Initial database name for RDS MySQL"
  type        = string
  default     = "mydb"
}

variable "rds_username" {
  description = "Master username for RDS MySQL"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Master password for RDS MySQL"
  type        = string
  sensitive   = true
}
