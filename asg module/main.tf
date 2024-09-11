# resource "tls_private_key" "this" {
#   count     = var.create_key_pair ? 1 : 0
#   algorithm = "RSA"
# }

# module "key_pair" {
#   count      = var.create_key_pair ? 1 : 0
#   source     = "terraform-aws-modules/key-pair/aws"
#   version    = "1.0.0"
#   key_name   = var.key_name
#   public_key = tls_private_key.this.0.public_key_openssh
# }

# resource "local_file" "this" {
#   count           = var.create_key_pair ? 1 : 0
#   content         = tls_private_key.this.0.private_key_pem
#   filename        = format("%s-%s", var.key_name, "private-key-pair.pem")
#   file_permission = "0600"
# }

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name                                  = var.ec2_sg_name
  use_name_prefix                       = var.use_name_prefix
  vpc_id                                = var.vpc_id
  ingress_with_cidr_blocks              = var.ingress_with_cidr_blocks
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id
  egress_with_cidr_blocks               = var.egress_with_cidr_blocks
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.9.0"

  name                       = var.name # A common name for the resource created using this module
  use_name_prefix            = var.use_name_prefix
  launch_template            = aws_launch_template.this.name
  lt_version                 = "$Latest" # aws_launch_template.this.latest_version
  use_lt                     = var.use_lt
  use_mixed_instances_policy = var.use_mixed_instances_policy
  mixed_instances_policy     = var.mixed_instances_policy
  vpc_zone_identifier        = var.vpc_zone_identifier
  min_size                   = var.min_size
  desired_capacity           = var.desired_capacity
  max_size                   = var.max_size
  capacity_rebalance         = var.capacity_rebalance
  min_elb_capacity           = var.min_elb_capacity
  wait_for_elb_capacity      = var.wait_for_elb_capacity
  default_cooldown           = var.default_cooldown
  target_group_arns          = var.target_group_arns
  health_check_type          = var.health_check_type
  health_check_grace_period  = var.health_check_grace_period
  termination_policies       = var.termination_policies
  enabled_metrics            = var.enabled_metrics
  metrics_granularity        = var.metrics_granularity
  service_linked_role_arn    = var.service_linked_role_arn
  instance_refresh           = var.instance_refresh
  tags_as_map                = var.asg_tags #Applied to both ASG and EC2, apart from the common tags of all resources.
  tag_specifications         = var.tag_specifications
}

resource "aws_autoscaling_notification" "this" {
  group_names   = [module.autoscaling.autoscaling_group_name]
  notifications = var.autoscaling_notifications
  topic_arn     = var.topic_arn
}

resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  count = var.create_cpu_scaling_policy ? 1 : 0

  name                   = "${var.name}-cpu-scaling-policy"
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
  # adjustment_type           = var.adjustment_type
  estimated_instance_warmup = var.estimated_instance_warmup
  policy_type               = var.policy_type
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_value
  }
}

resource "aws_autoscaling_policy" "scale_out_memory" {
  count = var.create_memory_scaling_policies ? 1 : 0

  name                      = "${var.name}-scale-out-memory-policy"
  autoscaling_group_name    = module.autoscaling.autoscaling_group_name
  adjustment_type           = var.adjustment_type
  estimated_instance_warmup = var.estimated_instance_warmup
  policy_type               = "StepScaling"

  metric_aggregation_type = "Average"
  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0.0
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_out_memory" {
  count = var.create_memory_scaling_policies ? 1 : 0

  alarm_name        = "${var.name}-scale-out-memory>${var.memory_scale_out_threshold}%"
  alarm_description = "${var.name}-scale-out-memory>${var.memory_scale_out_threshold}%"

  actions_enabled = true

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  period              = "300"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  statistic           = "Average"
  threshold           = var.memory_scale_out_threshold

  alarm_actions = [aws_autoscaling_policy.scale_out_memory[0].arn]

  dimensions = {
    AutoScalingGroupName = module.autoscaling.autoscaling_group_name
  }
}

resource "aws_autoscaling_policy" "scale_in_memory" {
  count = var.create_memory_scaling_policies ? 1 : 0

  name                      = "${var.name}-scale-in-memory-policy"
  autoscaling_group_name    = module.autoscaling.autoscaling_group_name
  adjustment_type           = var.adjustment_type
  estimated_instance_warmup = var.estimated_instance_warmup
  policy_type               = "StepScaling"

  metric_aggregation_type = "Average"
  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 0.0
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_in_memory" {
  count = var.create_memory_scaling_policies ? 1 : 0

  alarm_name        = "${var.name}-scale-in-memory<${var.memory_scale_in_threshold}%"
  alarm_description = "${var.name}-scale-in-memory<${var.memory_scale_in_threshold}%"

  actions_enabled = true

  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  datapoints_to_alarm = "3"
  period              = "300"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  statistic           = "Average"
  threshold           = var.memory_scale_in_threshold

  alarm_actions = [aws_autoscaling_policy.scale_in_memory[0].arn]

  dimensions = {
    AutoScalingGroupName = module.autoscaling.autoscaling_group_name
  }
}

resource "aws_launch_template" "this" {
  name                                 = "${var.name}-lt"
  description                          = "This is an LT used by ASG for ${var.name} servers"
  update_default_version               = var.update_default_version
  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = var.ebs_optimized
  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  monitoring {
    enabled = var.enable_monitoring
  }
  vpc_security_group_ids = [module.sg.security_group_id]
  user_data              = var.user_data_base64

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = block_device_mappings.value.device_name
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten([lookup(block_device_mappings.value, "ebs", [])])
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          iops                  = lookup(ebs.value, "iops", null)
          throughput            = lookup(ebs.value, "throughput", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }
  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification.value, "capacity_reservation_target", [])
        content {
          capacity_reservation_id = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
        }
      }
    }
  }
  dynamic "cpu_options" {
    for_each = var.cpu_options != null ? [var.cpu_options] : []
    content {
      core_count       = cpu_options.value.core_count
      threads_per_core = cpu_options.value.threads_per_core
    }
  }
  dynamic "credit_specification" {
    for_each = var.credit_specification != null ? [var.credit_specification] : []
    content {
      cpu_credits = credit_specification.value.cpu_credits
    }
  }
  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_name != null ? [var.iam_instance_profile_name] : []
    content {
      name = var.iam_instance_profile_name
    }
  }
  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", null)
      http_tokens                 = lookup(metadata_options.value, "http_tokens", null)
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", null)
      http_protocol_ipv6          = lookup(metadata_options.value, "http_protocol_ipv6", null)
    }
  }
  dynamic "placement" {
    for_each = var.placement != null ? [var.placement] : []
    content {
      affinity                = lookup(placement.value, "affinity", null)
      availability_zone       = lookup(placement.value, "availability_zone", null)
      group_name              = lookup(placement.value, "group_name", null)
      host_id                 = lookup(placement.value, "host_id", null)
      host_resource_group_arn = lookup(placement.value, "host_resource_group_arn", null)
      spread_domain           = lookup(placement.value, "spread_domain", null)
      tenancy                 = lookup(placement.value, "tenancy", null)
      partition_number        = lookup(placement.value, "partition_number", null)
    }
  }
  dynamic "tag_specifications" {
    for_each = var.tag_specifications
    content {
      resource_type = tag_specifications.value.resource_type
      tags          = tag_specifications.value.tags
    }
  }
}

resource "aws_autoscaling_lifecycle_hook" "ec2_instance_terminating" {
  count = var.create_termination_lifecycle_hook ? 1 : 0

  name                   = "LCH_EC2_INSTANCE_TERMINATING"
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
  default_result         = "CONTINUE"
  heartbeat_timeout      = var.heartbeat_timeout
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
}
