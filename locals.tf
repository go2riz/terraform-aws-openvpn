data "aws_region" "current" {}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

locals {
  # Role ARNs used by the task definition
  effective_task_role_arn = var.task_role_arn != null ? var.task_role_arn : (var.create_iam_role ? aws_iam_role.ecs_task[0].arn : null)
  effective_execution_role_arn = var.execution_role_arn != null ? var.execution_role_arn : (var.create_iam_role ? aws_iam_role.ecs_task[0].arn : null)

  container_definitions = [
    {
      name              = var.name
      image             = var.image
      memoryReservation = var.memory_reservation
      essential         = true
      portMappings = [
        {
          hostPort      = var.openvpn_port
          containerPort = var.openvpn_port
          protocol      = lower(var.openvpn_protocol)
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.default.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.name
        }
      }
      linuxParameters = {
        capabilities = {
          add = ["NET_ADMIN"]
        }
      }
      environment = [
        { name = "USERS", value = var.users },
        { name = "REVOKE_USERS", value = var.revoke_users },
        { name = "DOMAIN_NAME", value = var.domain_name },
        { name = "S3_BUCKET", value = aws_s3_bucket.vpn.id },
        { name = "ROUTE_PUSH", value = var.route_push },
      ]
      mountPoints = [
        {
          sourceVolume  = "openvpn-${var.name}"
          containerPath = "/etc/openvpn"
        }
      ]
    }
  ]
}
