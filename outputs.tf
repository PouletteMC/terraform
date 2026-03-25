output "iam_user_name" {
  description = "IAM user name"
  value       = aws_iam_user.user.name
}

output "iam_group_name" {
  description = "IAM group name"
  value       = aws_iam_group.group.name
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "ec2_public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.web.public_ip
}

output "ec2_ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.web.public_ip}"
}

output "ec2_http_url" {
  description = "HTTP URL to access Apache"
  value       = "http://${aws_instance.web.public_ip}"
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website.id
}

output "s3_website_url" {
  description = "S3 static website URL"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudtrail_name" {
  description = "CloudTrail trail name"
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail.id
}

output "cloudwatch_dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alerts"
  value       = aws_sns_topic.alerts.arn
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_connect_command" {
  description = "Commande MySQL pour se connecter depuis EC2"
  value       = "mysql -h ${aws_db_instance.mysql.address} -P 3306 -u ${var.rds_username} -p"
}

output "dynamodb_efrei_table_name" {
  description = "Nom de la table DynamoDB du lab"
  value       = aws_dynamodb_table.efrei.name
}

output "dynamodb_efrei_table_arn" {
  description = "ARN de la table DynamoDB (nécessaire pour export S3)"
  value       = aws_dynamodb_table.efrei.arn
}
