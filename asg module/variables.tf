################################### ASG ########################################

variable "asg_tags" {
  description = "Tags for both ASG and ec2 instances launched by it"
  type        = map(any)
  default     = {}

}
variable "name" {
  description = "Name used across the resources created"
  type        = string
  default     = ""
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = 10
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = 2
}

variable "capacity_rebalance" {
  description = "Indicates whether capacity rebalance is enabled"
  type        = bool
  default     = true
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  type        = number
  default     = 1
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
  type        = number
  default     = 1
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 30
}

variable "target_group_arns" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 60
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default`"
  type        = list(string)
  default     = ["Default"]
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are `GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances`, `GroupTotalCapacity`, `GroupTotalInstances`"
  type        = list(string)
  default     = null
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is `1Minute`"
  type        = string
  default     = "1Minute"
}

variable "service_linked_role_arn" {
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
  type        = string
  default     = null
}

variable "instance_refresh" {
  description = "If this block is configured, start an Instance Refresh when this Auto Scaling Group is updated"
  type        = any
  default     = null
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
  default     = null
}

variable "use_mixed_instances_policy" {
  description = "Determines whether to use a mixed instances policy in the autoscaling group or not"
  type        = bool
  default     = true
}

variable "mixed_instances_policy" {
  description = "Configuration block containing settings to define launch targets for Auto Scaling groups"
  type        = any
  default     = null
}

variable "topic_arn" {
  description = "SNS notification topic arn"
  type        = string
  default     = null
}

variable "create_cpu_scaling_policy" {
  description = "Whether to create CPU based autoscaling policy or not"
  type        = bool
  default     = true
}

variable "create_memory_scaling_policies" {
  description = "Whether to create memory based autoscaling polices and alarms or not"
  type        = bool
  default     = false
}

variable "adjustment_type" {
  description = "adjustment type for autoscaling policy. Supported values: ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity"
  type        = string
  default     = "ExactCapacity"
}

variable "policy_type" {
  description = "The policy type, either SimpleScaling, StepScaling, TargetTrackingScaling, or PredictiveScaling"
  type        = string
  default     = "TargetTrackingScaling"
}

variable "target_value" {
  description = "The target value for the metric, used in autoscaling policy of type - TargetTrackingScaling"
  type        = string
  default     = "50.0"
}

variable "memory_scale_in_threshold" {
  description = "The threshold for memory based alarm scale-in activity"
  type        = string
  default     = "85"
}

variable "memory_scale_out_threshold" {
  description = "The threshold for memory based alarm scale-out activity"
  type        = string
  default     = "60"
}

variable "estimated_instance_warmup" {
  description = "The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics"
  type        = string
  default     = "60"
}

variable "update_default_version" {
  description = "(LT) Whether to update Default Version each update. Conflicts with `default_version`"
  type        = bool
  default     = true
}

variable "block_device_mappings" {
  description = "(LT) Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = list(any)
  default     = []
}

variable "capacity_reservation_specification" {
  description = "(LT) Targeting for EC2 capacity reservations"
  type        = any
  default     = null
}

variable "cpu_options" {
  description = "(LT) The CPU options for the instance"
  type        = map(string)
  default     = null
}

variable "credit_specification" {
  description = "(LT) Customize the credit specification of the instance"
  type        = map(string)
  default     = null
}

variable "disable_api_termination" {
  description = "(LT) If true, enables EC2 instance termination protection"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "iam_instance_profile_name" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = string
  default     = null
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
  default     = null
}

variable "use_lt" {
  description = "Determines whether to use a launch template in the autoscaling group or not"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "(LT) Shutdown behavior for the instance. Can be `stop` or `terminate`. (Default: `stop`)"
  type        = string
  default     = "terminate"
}

variable "instance_type" {
  description = "The type of the instance to launch"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = false
}

variable "tag_specifications" {
  description = "(LT) The tags to apply to the resources during launch"
  type        = list(any)
  default     = []
}

variable "user_data_base64" {
  description = "The Base64-encoded user data to provide when launching the instance. You should use this for Launch Templates instead user_data"
  type        = string
  default     = null
}

variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default     = null
}

variable "placement" {
  description = "(LT) The placement of the instance"
  type        = map(string)
  default     = null
}

variable "autoscaling_notifications" {
  description = "List of Notification Types that trigger notifications."
  type        = list(string)
  default     = null
}

################################### SG ########################################

variable "ec2_sg_name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type        = list(map(string))
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix or fixed name. Should be true to able to update security group name after initial creation"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
  default     = null
}

################################
# aws_autoscaling_lifecycle_hook
################################

variable "create_termination_lifecycle_hook" {
  description = "Whether to create EC2 Instance-terminate Lifecycle Hook or not."
  type        = bool
  default     = false
}

variable "heartbeat_timeout" {
  description = "(Optional) Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the DefaultResult parameter."
  type        = number
  default     = 180
}
