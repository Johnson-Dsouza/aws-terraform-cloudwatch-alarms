#CloudWatch Alarm for CPU Usage
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name  = "Coolify-Server-CPU-Alarm"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "80"
  period              = "60"
  evaluation_periods  = "1"

  dimensions = {
    InstanceId = "${var.instance_id}"
  }

  alarm_actions = ["${aws_sns_topic.sns_topic_alarms.arn}"]
}

#CloudWatch Alarm for Memory Usage
resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name  = "Coolify-Server-Memory-Alarm"
  namespace   = "CWAgent"
  metric_name = "mem_used_percent"

  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "80"
  period              = "60"
  evaluation_periods  = "1"

  dimensions = {
    InstanceId = "${var.instance_id}"

  }

  alarm_actions = ["${aws_sns_topic.sns_topic_alarms.arn}"]
}

#CloudWatch Alarm for Disk Usage
resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name  = "Coolify-Server-Disk-Alarm"
  namespace   = "CWAgent"
  metric_name = "disk_used_percent"

  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "10"
  period              = "60"
  evaluation_periods  = "1"

  dimensions = {
    path       = "/"
    InstanceId = "${var.instance_id}"
    device     = "xvda1"
    fstype     = "ext4"
  }

  alarm_actions = ["${aws_sns_topic.sns_topic_alarms.arn}"]
}
