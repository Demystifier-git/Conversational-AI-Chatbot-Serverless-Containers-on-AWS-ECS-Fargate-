#################################################
# ECS Service Scaling Target
#################################################
resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.my_cluster.name}/${aws_ecs_service.my_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_sns_topic" "autoscaling_notifications" {
  name = "ecs-autoscaling-notifications"
}

#################################################
# ========== CPU SCALING ==========

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "ecs-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    ClusterName = aws_ecs_cluster.my_cluster.name
    ServiceName = aws_ecs_service.my_service.name
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_step_scale_out.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "ecs-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    ClusterName = aws_ecs_cluster.my_cluster.name
    ServiceName = aws_ecs_service.my_service.name
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_step_scale_in.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

# Step Scaling Policies
resource "aws_appautoscaling_policy" "cpu_step_scale_out" {
  name               = "cpu-step-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 20
      scaling_adjustment          = 1
    }
    step_adjustment {
      metric_interval_lower_bound = 20
      metric_interval_upper_bound = 40
      scaling_adjustment          = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 40
      scaling_adjustment          = 4
    }
  }
}

resource "aws_appautoscaling_policy" "cpu_step_scale_in" {
  name               = "cpu-step-scale-in"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 30
      metric_interval_upper_bound = 50
      scaling_adjustment          = -1
    }
    step_adjustment {
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 70
      scaling_adjustment          = -2
    }
    step_adjustment {
      metric_interval_lower_bound = 70
      scaling_adjustment          = -4
    }
  }
}

#################################################
# ========== MEMORY SCALING ==========
#################################################
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "ecs-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75

  dimensions = {
    ClusterName = aws_ecs_cluster.my_cluster.name
    ServiceName = aws_ecs_service.my_service.name
  }

  alarm_actions = [
    aws_appautoscaling_policy.memory_step_scale_out.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_memory" {
  alarm_name          = "ecs-low-memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    ClusterName = aws_ecs_cluster.my_cluster.name
    ServiceName = aws_ecs_service.my_service.name
  }

  alarm_actions = [
    aws_appautoscaling_policy.memory_step_scale_in.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_appautoscaling_policy" "memory_step_scale_out" {
  name               = "memory-step-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 20
      scaling_adjustment          = 1
    }
    step_adjustment {
      metric_interval_lower_bound = 20
      metric_interval_upper_bound = 40
      scaling_adjustment          = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 40
      scaling_adjustment          = 4
    }
  }
}

resource "aws_appautoscaling_policy" "memory_step_scale_in" {
  name               = "memory-step-scale-in"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 30
      metric_interval_upper_bound = 50
      scaling_adjustment          = -1
    }
    step_adjustment {
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 70
      scaling_adjustment          = -2
    }
    step_adjustment {
      metric_interval_lower_bound = 70
      scaling_adjustment          = -4
    }
  }
}

#################################################
# ========== ALB REQUESTS SCALING ==========
#################################################
resource "aws_cloudwatch_metric_alarm" "high_alb_requests" {
  alarm_name          = "alb-requests-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 100

  dimensions = {
    TargetGroup  = data.aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = data.aws_lb.my_alb.arn_suffix
  }

  alarm_actions = [
    aws_appautoscaling_policy.alb_step_scale_out.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_alb_requests" {
  alarm_name          = "alb-requests-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10

  dimensions = {
    TargetGroup  = data.aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = data.aws_lb.my_alb.arn_suffix
  }

  alarm_actions = [
    aws_appautoscaling_policy.alb_step_scale_in.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_appautoscaling_policy" "alb_step_scale_out" {
  name               = "alb-step-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 50
      scaling_adjustment          = 1
    }
    step_adjustment {
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 100
      scaling_adjustment          = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 100
      scaling_adjustment          = 4
    }
  }
}

resource "aws_appautoscaling_policy" "alb_step_scale_in" {
  name               = "alb-step-scale-in"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 10
      metric_interval_upper_bound = 50
      scaling_adjustment          = -1
    }
    step_adjustment {
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 100
      scaling_adjustment          = -2
    }
    step_adjustment {
      metric_interval_lower_bound = 100
      scaling_adjustment          = -4
    }
  }
}

#################################################
# ========== LATENCY SCALING ==========
#################################################
resource "aws_cloudwatch_metric_alarm" "high_latency" {
  alarm_name          = "alb-high-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0.5 # 500ms

  dimensions = {
    TargetGroup  = data.aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = data.aws_lb.my_alb.arn_suffix
  }

  alarm_actions = [
    aws_appautoscaling_policy.latency_step_scale_out.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_appautoscaling_policy" "latency_step_scale_out" {
  name               = "latency-step-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 1
      scaling_adjustment          = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 1
      scaling_adjustment          = 4
    }
  }
}

#################################################
# ========== ERROR RATE SCALING ==========
#################################################
resource "aws_cloudwatch_metric_alarm" "high_5xx" {
  alarm_name          = "alb-high-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 20

  dimensions = {
    TargetGroup  = data.aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = data.aws_lb.my_alb.arn_suffix
  }

  alarm_actions = [
    aws_appautoscaling_policy.error_step_scale_out.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_appautoscaling_policy" "error_step_scale_out" {
  name               = "error-step-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 10
      scaling_adjustment          = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 10
      scaling_adjustment          = 3
    }
  }
}

#################################################
# ========== SQS QUEUE DEPTH SCALING ==========
#################################################
resource "aws_sqs_queue" "my_queue" {
  name = "my-queue"
}

resource "aws_cloudwatch_metric_alarm" "high_sqs_queue" {
  alarm_name          = "sqs-queue-depth-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 100

  dimensions = {
    QueueName = aws_sqs_queue.my_queue.name
  }

  alarm_actions = [
    aws_appautoscaling_policy.sqs_step_scale_out.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_sqs_queue" {
  alarm_name          = "sqs-queue-depth-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    QueueName = aws_sqs_queue.my_queue.name
  }

  alarm_actions = [
    aws_appautoscaling_policy.sqs_step_scale_in.arn,
    aws_sns_topic.autoscaling_notifications.arn
  ]
  ok_actions = [aws_sns_topic.autoscaling_notifications.arn]
}

resource "aws_appautoscaling_policy" "sqs_step_scale_out" {
  name               = "sqs-step-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 50
      scaling_adjustment          = 1
    }
    step_adjustment {
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 100
      scaling_adjustment          = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 100
      scaling_adjustment          = 4
    }
  }
}

resource "aws_appautoscaling_policy" "sqs_step_scale_in" {
  name               = "sqs-step-scale-in"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 10
      metric_interval_upper_bound = 50
      scaling_adjustment          = -1
    }
    step_adjustment {
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 100
      scaling_adjustment          = -2
    }
    step_adjustment {
      metric_interval_lower_bound = 100
      scaling_adjustment          = -4
    }
  }
}




