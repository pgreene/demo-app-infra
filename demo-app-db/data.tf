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

data "aws_acm_certificate" "pdcw" {
  domain = "*.pgcprofessional.com"
  #types = ["AMAZON_ISSUED"]
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
