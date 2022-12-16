resource "aws_sns_topic" "sns_topic_alarms" {
  name = "InstanceEventOver80Percent"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.sns_topic_alarms.arn
  protocol  = "lambda"

  endpoint = aws_lambda_function.cloudwatch_alarms_to_slack.arn
}

resource "aws_sns_topic_policy" "policy" {
  arn = aws_sns_topic.sns_topic_alarms.arn

  policy = data.aws_iam_policy_document.sns.json
}

data "aws_iam_policy_document" "sns" {
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      "${aws_sns_topic.sns_topic_alarms.arn}",
    ]
  }
}
