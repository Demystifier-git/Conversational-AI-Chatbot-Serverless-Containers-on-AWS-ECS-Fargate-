###########################
# Package Lambda Code
###########################
resource "null_resource" "zip_rds_lambda" {
  provisioner "local-exec" {
    # Windows PowerShell command to zip
    command = "powershell Compress-Archive -Path ${path.module}/rds_lambda/rds_scale_lambda.py -DestinationPath ${path.module}/rds_lambda/rds_scale_lambda.zip -Force"
  }

  triggers = {
    source_hash = filemd5("${path.module}/rds_lambda/rds_scale_lambda.py")
  }
}

resource "aws_lambda_function" "rds_scale_lambda" {
  function_name = "rds-scale-lambda"
  role          = aws_iam_role.lambda_rds_scaling_role.arn
  handler       = "rds_scale_lambda.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/rds_lambda/rds_scale_lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/rds_lambda/rds_scale_lambda.zip")

  environment {
    variables = {
      DB_INSTANCE_ID = data.aws_db_instance.existing.db_instance_identifier
    }
  }

  depends_on = [null_resource.zip_rds_lambda]
}


