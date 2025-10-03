resource "aws_iam_role" "lambda_rds_scaling_role" {
  name = "lambda-rds-scaling-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_rds_scaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach RDS full access
resource "aws_iam_role_policy_attachment" "lambda_rds_full" {
  role       = aws_iam_role.lambda_rds_scaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
