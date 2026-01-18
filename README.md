# terraform-aws-openvpn (Terraform 1.x)

This module provisions an **OpenVPN ECS task/service** and supporting AWS resources:

- ECS task definition + ECS service (EC2 launch type)
- CloudWatch log group
- S3 bucket for VPN artifacts (client profiles/keys)
- Optional security group that allows *VPN client CIDRs* to access internal resources

## Compatibility

- Terraform: **>= 1.3.0**
- AWS provider: **~> 5.0**

## Example usage

```hcl
module "openvpn" {
  source = "git::https://github.com/go2riz/terraform-aws-openvpn.git?ref=<tag-or-commit>"

  name         = "mgmt"
  cluster_name = module.ecs.cluster_name
  vpc_id       = module.vpc.vpc_id

  # OpenVPN
  openvpn_port     = 1194
  openvpn_protocol = "udp"
  domain_name      = "openvpn.example.com"

  # VPN users
  users        = "alice,bob"
  revoke_users = ""

  # Routes to push to clients
  route_push = "10.100.0.0 255.255.0.0"

  # Allow VPN clients to access internal resources
  requester_cidrs = ["10.8.0.0/24"]

  tags = {
    Project = "vpn"
  }
}
```

## IAM role override (optional)

By default, the module creates an ECS task IAM role and attaches:

- AmazonECSTaskExecutionRolePolicy
- SSM read permissions for Parameter Store
- S3 read/write permissions to the module-managed bucket

If you want to use a pre-existing role (for example, a role created by your ECS cluster module):

```hcl
module "openvpn" {
  # ... other settings ...

  create_iam_role     = false
  task_role_arn       = module.ecs_vpn.ecs_task_iam_role_arn
  execution_role_arn  = module.ecs_vpn.ecs_task_iam_role_arn
}
```

When `create_iam_role = false`, this module will **not** create or attach IAM policies. Ensure the provided role already has the required permissions.

## Key outputs

- `ecs_service_name`
- `ecs_task_definition_arn`
- `ecs_task_role_arn`
- `log_group_name`
- `s3_bucket_id`, `s3_bucket_arn`
- `openvpn_access_security_group_id`
