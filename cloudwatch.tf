resource "aws_cloudwatch_dashboard" "cloudtrail" {
  dashboard_name = "cloudtrail-${var.account_name}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 8
        height = 6
        properties = {
          title   = "All API Calls"
          view    = "timeSeries"
          region  = var.aws_region
          metrics = [["CloudTrailMetrics", "AllApiCallCount"]]
          period  = 300
          stat    = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 0
        width  = 8
        height = 6
        properties = {
          title   = "Console Sign-In Events"
          view    = "timeSeries"
          region  = var.aws_region
          metrics = [["CloudTrailMetrics", "ConsoleSignInCount"]]
          period  = 300
          stat    = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 0
        width  = 8
        height = 6
        properties = {
          title   = "Unauthorized API Calls"
          view    = "timeSeries"
          region  = var.aws_region
          metrics = [["CloudTrailMetrics", "UnauthorizedApiCallCount"]]
          period  = 300
          stat    = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 8
        height = 6
        properties = {
          title   = "Root Account Usage"
          view    = "timeSeries"
          region  = var.aws_region
          metrics = [["CloudTrailMetrics", "RootAccountUsageCount"]]
          period  = 300
          stat    = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 6
        width  = 8
        height = 6
        properties = {
          title   = "IAM Changes"
          view    = "timeSeries"
          region  = var.aws_region
          metrics = [["CloudTrailMetrics", "IAMChangeCount"]]
          period  = 300
          stat    = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 6
        width  = 8
        height = 6
        properties = {
          title   = "Security Group Changes"
          view    = "timeSeries"
          region  = var.aws_region
          metrics = [["CloudTrailMetrics", "SecurityGroupChangeCount"]]
          period  = 300
          stat    = "Sum"
        }
      }
    ]
  })
}

resource "aws_sns_topic" "alerts" {
  name = "cloudwatch-alerts-${var.account_name}"

  tags = {
    Name = "cloudwatch-alerts-${var.account_name}"
  }
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "dashboard-${var.account_name}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 8
        height = 6
        properties = {
          title  = "EC2 CPU Utilization"
          view   = "timeSeries"
          region = var.aws_region
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.web.id]
          ]
          period = 300
          stat   = "Average"
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 0
        width  = 8
        height = 6
        properties = {
          title  = "EC2 Network In"
          view   = "timeSeries"
          region = var.aws_region
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.web.id]
          ]
          period = 300
          stat   = "Average"
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 0
        width  = 8
        height = 6
        properties = {
          title  = "EC2 Network Out"
          view   = "timeSeries"
          region = var.aws_region
          metrics = [
            ["AWS/EC2", "NetworkOut", "InstanceId", aws_instance.web.id]
          ]
          period = 300
          stat   = "Average"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high-${var.account_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeds 80%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  tags = {
    Name = "cpu-alarm-${var.account_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in_high" {
  alarm_name          = "network-in-high-${var.account_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "NetworkIn exceeds 10 bytes"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  tags = {
    Name = "network-in-alarm-${var.account_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_out_high" {
  alarm_name          = "network-out-high-${var.account_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "NetworkOut exceeds 10 bytes"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  tags = {
    Name = "network-out-alarm-${var.account_name}"
  }
}
