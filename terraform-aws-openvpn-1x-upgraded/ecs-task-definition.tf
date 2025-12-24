resource "aws_ecs_task_definition" "default" {
  family = "openvpn-${var.name}"

  execution_role_arn = aws_iam_role.ecs_task.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  volume {
    name      = "openvpn-${var.name}"
    host_path = "/mnt/efs/openvpn-${var.name}"
  }

  container_definitions = jsonencode(local.container_definitions)
}
