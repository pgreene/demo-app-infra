module "cloudwatch_metric_alarm_db" {
  source  = "app.terraform.io/pgconsulting/cloudwatch-metric-alarm/aws"
  version = "1.0.0"
  name = local.name
  metric_name = "VolumeReadIOPs"
  metric_namespace = "AWS/RDS"
  alarm_description = "Volume Read IOPS"
  comparison_operator = "GreaterThanThreshold"
  period = 3600
  #datapoints_to_alarm = "1"
  evaluation_periods = "1"
  treat_missing_data = "notBreaching"
  statistic = "Average"
  threshold = "1000"
  insufficient_data_actions = [data.aws_sns_topic.sev2.arn]
  alarm_actions = [data.aws_sns_topic.sev2.arn]
  ok_actions = [data.aws_sns_topic.sev2.arn]
  dimensions = {DBClusterIdentifier = module.aws_rds_cluster_aurora_serverless.id}
  tags = local.tags
  depends_on = [
    module.aws_rds_cluster_aurora_serverless
  ]
}