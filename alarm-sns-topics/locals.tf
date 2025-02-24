locals {
    account_id = "358665735850"
    region = "ca-central-1"
    product = "demo-app-infra"
    env = "ops"
    prefix = "alarm-sns-topics"
    name = join("-",[local.env,local.prefix])
    creator = "terraform"
    owner = "pgreene"
    alarm_endpoint = "pgcprofessional@gmail.com"
    tags = {
        Name = local.name
        Product = local.product
        Environment = local.env
        Creator = local.creator
        Owner = local.owner
    }
    terraform_organization_id = "pgconsulting"
}
