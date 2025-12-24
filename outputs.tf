output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.default.name
}

output "ecs_task_definition_arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.default.arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.default.name
}

output "s3_bucket_id" {
  description = "S3 bucket ID used for VPN artifacts"
  value       = aws_s3_bucket.vpn.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN used for VPN artifacts"
  value       = aws_s3_bucket.vpn.arn
}

output "openvpn_access_security_group_id" {
  description = "Security group ID that allows VPN client CIDRs to access resources (only created when requester_cidrs is non-empty)"
  value       = length(aws_security_group.openvpn) > 0 ? aws_security_group.openvpn[0].id : null
}

output "ecs_task_role_arn" {
  description = "IAM role ARN used by the ECS task"
  value       = aws_iam_role.ecs_task.arn
}
