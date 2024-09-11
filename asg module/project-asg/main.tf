module "autoscaling" {
source = "../asg module"

    name = "autoscaling"
    use_name_prefix = false
    key_name = "demo"
    ec2_sg_name = "launch-wizard-1"
    vpc_id = "vpc-b709e5d1"
    ingress_with_cidr_blocks = 
    ingress_with_source_security_group_id = 
    egress_with_cidr_blocks = 
    use_lt = false
    use_mixed_instances_policy = true
    mixed_instances_policy = true
    vpc_zone_identifier = "subnet-aa37dcf0"
    min_size = 1
    desired_capacity = 5
    max_size = 10
    capacity_rebalance = 4
    min_elb_capacity = 2
    wait_for_elb_capacity = 2
    default_cooldown = 30
    target_group_arns = 
    health_check_type = "ec2"
    health_check_grace_period = 60
    termination_policies = ['OldestInstance','OldestLaunchConfiguration']
    enabled_metrics = ["`GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances`, `GroupTotalCapacity`, `GroupTotalInstances`"]
    metrics_granularity = "1Minute"
    service_linked_role_arn = 
    instance_refresh = true
    tag_specifications = 
    autoscaling_notifications = ["autoscaling:EC2_INSTANCE_LAUNCH", "autoscaling:EC2_INSTANCE_TERMINATE"]
    topic_arn = "arn:aws:sns:us-west-1:779527285137:asgsns"
    create_cpu_scaling_policy = true
    adjustment_type = "ExactCapacity"
    estimated_instance_warmup = "60"
    policy_type = "TargetTrackingScaling"
    target_value = "50.0"
    create_memory_scaling_policies = false
    memory_scale_out_threshold = "60"
    memory_scale_in_threshold = "85"
    update_default_version = true
    disable_api_termination = false
    ebs_optimized = false
    image_id = "ami-025258b26b492aec6"
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t2.micro"
    enable_monitoring = false
    user_data_base64 = 
    block_device_mappings = 10
    capacity_reservation_specification = 
    cpu_options = 
    credit_specification = 
    iam_instance_profile_name = 
    metadata_options = 
    placement = 
    

}

