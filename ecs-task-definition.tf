resource "aws_ecs_task_definition" "default" {
  family = "openvpn-${var.name}"

  execution_role_arn = local.effective_execution_role_arn
  task_role_arn      = local.effective_task_role_arn

  volume {
    name      = "openvpn-${var.name}"
    host_path = "/mnt/efs/openvpn-${var.name}"
  }

  container_definitions = jsonencode(local.container_definitions)
}
