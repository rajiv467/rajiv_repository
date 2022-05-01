resource "aws_appautoscaling_target" "target" {
  resource_id        = "service/${var.cluster_name}/${var.ecs_service_name}"
  role_arn           = data.aws_iam_role.autoscale_role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  service_namespace  = "ecs"
}

data "aws_iam_role" "autoscale_role" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.project}-cpu-utilization-above-${var.scale_up_threshold}"
  alarm_description   = "This alarm monitors ${var.project} CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_up.arn]

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.ecs_service_name
  }
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.project}-scale-up"
  resource_id        = "service/${var.cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "${var.project}-cpu-utilization-below-${var.scale_down_threshold}"
  alarm_description   = "This alarm monitors ${var.project} CPU utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_down_threshold
  alarm_actions       = [aws_appautoscaling_policy.service_scale_down.arn]

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.ecs_service_name
  }
}

resource "aws_appautoscaling_policy" "service_scale_down" {
  name               = "${var.project}-scale-down-${var.scale_down_threshold}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.ecs_service_name}"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"
    step_adjustment {
      //      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

