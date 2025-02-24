//module "kms" {
//  source = "app.terraform.io/pgconsulting/kms/aws"
//  version = "1.0.1"
//  description = "used for encrypting alarm messages"
//  kms_is_enabled = true
//  enable_key_rotation = true
//  deletion_window_in_days = 7
//  tags = local.tags
//}

module "aws_sns_sev1" {
    source = "app.terraform.io/pgconsulting/sns/aws"
    version = "1.0.2"
    name = "sev1"
    account_id = local.account_id
    kms_master_key_id = "alias/aws/sns"
    tags = merge(local.tags,tomap({Name = "sev1"})) 
}

module "aws_sns_topic_sev1" {
    source = "app.terraform.io/pgconsulting/sns-topic-subscription/aws"
    version = "1.0.0"
    protocol = "sms"
    raw_message_delivery = "false"
    endpoint = "+16476327798"
    topic_arn = module.aws_sns_sev1.arn
    //tags = merge(local.tags,tomap({Name = "sev1"}))
}

module "aws_sns_sev2" {
    source = "app.terraform.io/pgconsulting/sns/aws"
    version = "1.0.2"
    name = "sev2"
    account_id = local.account_id
    kms_master_key_id = "alias/aws/sns"
    tags = merge(local.tags,tomap({Name = "sev2"})) 
}

module "aws_sns_topic_sev2" {
    source = "app.terraform.io/pgconsulting/sns-topic-subscription/aws"
    version = "1.0.0"
    protocol = "email"
    raw_message_delivery = "false"
    endpoint = local.alarm_endpoint
    topic_arn = module.aws_sns_sev2.arn
    //tags = merge(local.tags,tomap({Name = "sev2"}))
}

module "aws_sns_sev3" {
    source = "app.terraform.io/pgconsulting/sns/aws"
    version = "1.0.2"
    name = "sev3"
    account_id = local.account_id
    kms_master_key_id = "alias/aws/sns"
    tags = merge(local.tags,tomap({Name = "sev3"})) 
}

module "aws_sns_topic_sev3" {
    source = "app.terraform.io/pgconsulting/sns-topic-subscription/aws"
    version = "1.0.0"
    protocol = "email"
    raw_message_delivery = "false"
    endpoint = local.alarm_endpoint
    topic_arn = module.aws_sns_sev3.arn
    //tags = merge(local.tags,tomap({Name = "sev3"}))  
}
