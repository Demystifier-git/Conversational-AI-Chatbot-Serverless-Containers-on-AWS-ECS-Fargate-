#################################################
# RDS Auto-Scaling - Terraform
#################################################

# SNS Topic for RDS Scaling Notifications
resource "aws_sns_topic" "rds_scaling_notifications" {
  name = "rds-scaling-notifications"
}

# CloudWatch Alarms for RDS CPU
resource "aws_cloudwatch_metric_alarm" "high_db_cpu" {
  alarm_name          = "rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.existing.id
  }

  alarm_actions = [aws_sns_topic.rds_scaling_notifications.arn]
  ok_actions    = [aws_sns_topic.rds_scaling_notifications.arn]
}

# CloudWatch Alarms for RDS Connections
resource "aws_cloudwatch_metric_alarm" "high_db_connections" {
  alarm_name          = "rds-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.existing.id
  }

  alarm_actions = [aws_sns_topic.rds_scaling_notifications.arn]
  ok_actions    = [aws_sns_topic.rds_scaling_notifications.arn]
}





# SNS Subscription to Invoke Lambda
resource "aws_sns_topic_subscription" "rds_scaling_subscription" {
  topic_arn = aws_sns_topic.rds_scaling_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_scale_lambda.arn
}

# Allow SNS to invoke Lambda
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_scale_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.rds_scaling_notifications.arn
}
