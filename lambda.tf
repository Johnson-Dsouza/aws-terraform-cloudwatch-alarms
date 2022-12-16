# Create an IAM role for the lambda function
resource "aws_iam_role" "lambda_role" {
  name = "send-cloudwatch-alarms-to-slack"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Allow lambda to write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "send_cloudwatch_alarms_to_slack_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Creates ZIP archive with lambda function
data "archive_file" "slack" {
  type        = "zip"
  source_file = "${path.module}/Lambda/Cloudwatch-Alarms/slack.py"
  output_path = "${path.module}/Lambda/Cloudwatch-Alarms.zip"
}

# Lambda function resource  
resource "aws_lambda_function" "cloudwatch_alarms_to_slack" {
  filename      = data.archive_file.slack.output_path
  function_name = "slack"

  role             = aws_iam_role.lambda_role.arn
  handler          = "slack.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.slack.output_base64sha256

  environment {
    variables = {
      WEBHOOK_URL = var.webhook_url
    }
  }

}

#External source (i.e. SNS )permission to access the Lambda function.
resource "aws_lambda_permission" "sns_alarms" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_alarms_to_slack.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sns_topic_alarms.arn
}

