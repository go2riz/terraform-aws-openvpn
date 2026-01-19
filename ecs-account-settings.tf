// -----------------------------------------------------------------------------
// ECS account settings (region-scoped)
//
// "Long ARN" format is an AWS ECS account setting that can be enabled per region.
// It's a common "aging" issue for older accounts where ECS resources were created
// with "short" ARNs.
//
// Important behavior:
// - Enabling these settings affects NEW resources created after enabling.
// - Existing ECS services/tasks keep their ARN format until they are re-created.
//
// Keep this optional to avoid disturbing other stacks that share the account.
// -----------------------------------------------------------------------------

resource "aws_ecs_account_setting_default" "service_long_arn" {
  count = var.enable_ecs_long_arn_formats ? 1 : 0

  name  = "serviceLongArnFormat"
  value = "enabled"
}

resource "aws_ecs_account_setting_default" "task_long_arn" {
  count = var.enable_ecs_long_arn_formats ? 1 : 0

  name  = "taskLongArnFormat"
  value = "enabled"
}

resource "aws_ecs_account_setting_default" "container_instance_long_arn" {
  count = var.enable_ecs_long_arn_formats ? 1 : 0

  name  = "containerInstanceLongArnFormat"
  value = "enabled"
}
