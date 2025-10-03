#SNS Topic for notifications
resource "aws_sns_topic_subscription" "autoscaling_email_sub" {
  topic_arn = aws_sns_topic.autoscaling_notifications.arn
  protocol  = "email"
  endpoint  = "delightdavid1234@gmail.com" 
}

############################################
# SNS Topic Policy (allow CloudWatch to publish)
############################################
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.autoscaling_notifications.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }
}

resource "aws_sns_topic_policy" "autoscaling_notifications_policy" {
  arn    = aws_sns_topic.autoscaling_notifications.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

