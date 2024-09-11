## ASG ##

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = aws_launch_template.this.arn
}

output "launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = aws_launch_template.this.latest_version
}

output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.autoscaling.autoscaling_group_id
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = module.autoscaling.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = module.autoscaling.autoscaling_group_arn
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = module.autoscaling.autoscaling_group_min_size
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = module.autoscaling.autoscaling_group_max_size
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = module.autoscaling.autoscaling_group_desired_capacity
}

output "autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = module.autoscaling.autoscaling_group_health_check_type
}

output "autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.autoscaling.autoscaling_group_load_balancers
}

# ## KEY_PAIR ##

# output "key_pair_key_name" {
#   description = "The key pair name."
#   value       = module.key_pair[0].key_pair_key_name
# }

# output "key_pair_key_pair_id" {
#   description = "The key pair ID."
#   value       = module.key_pair[0].key_pair_key_pair_id
# }

# output "key_pair_fingerprint" {
#   description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716."
#   value       = module.key_pair[0].key_pair_fingerprint
# }

# ## SECURITY_GROUP ##

# output "security_group_name" {
#   description = "name of security group"
#   value = module.sg.security_group_name
# }
