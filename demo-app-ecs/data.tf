data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["dev-demo-app-vpc"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    "Name" = "dev-demo-app-vpc-private"
  }
}

data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    "Name" = "dev-demo-app-vpc-public"
  }
}

data "aws_acm_certificate" "url" {
  domain = "*.pgcprofessional.com"
  most_recent = true
}

data "aws_route53_zone" "selected" {
  name = "pgcprofessional.com."
  private_zone = false
}

data "aws_sns_topic" "sev1" {
  name = "sev1"
}

data "aws_sns_topic" "sev2" {
  name = "sev2"
}

data "aws_sns_topic" "sev3" {
  name = "sev3"
}

#data "aws_service_discovery_dns_namespace" "general" {
#  name = "dev-demo-app-ecs"
#  type = "DNS_PRIVATE"
#}
