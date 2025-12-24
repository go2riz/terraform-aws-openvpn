# == REQUIRED VARS

variable "name" {
  description = "Name of your ECS service"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "ECS cluster name or ARN"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# == OPTIONAL VARS

variable "image" {
  description = "OpenVPN container image"
  type        = string
  default     = "dnxsolutions/openvpn:1.0.3"
}

variable "openvpn_port" {
  description = "Port exposed by the OpenVPN container"
  type        = number
  default     = 1194
}

variable "openvpn_protocol" {
  description = "Transport protocol for OpenVPN"
  type        = string
  default     = "udp"

  validation {
    condition     = contains(["udp", "tcp"], lower(var.openvpn_protocol))
    error_message = "openvpn_protocol must be udp or tcp."
  }
}

variable "memory_reservation" {
  description = "Container memory reservation (MiB)"
  type        = number
  default     = 256
}

variable "requester_cidrs" {
  description = "List of CIDRs to add to openvpn-access SG so VPN clients can connect to resources"
  type        = list(string)
  default     = []
}

variable "users" {
  description = "List of users (comma-separated, no spaces) to create keys"
  type        = string
  default     = ""
}

variable "revoke_users" {
  description = "List of users (comma-separated, no spaces) to revoke previously created keys"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name to point to openvpn container for external access"
  type        = string
  default     = "vpn.address"
}

variable "route_push" {
  description = "List of routes to push to client (comma-separated, ex: '10.100.0.0 255.255.0.0,10.200.0.0 255.255.0.0')"
  type        = string
  default     = ""
}

variable "log_retention_in_days" {
  description = "CloudWatch log group retention"
  type        = number
  default     = 30
}

variable "s3_force_destroy" {
  description = "Whether to allow Terraform to destroy the S3 bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to supported resources"
  type        = map(string)
  default     = {}
}
