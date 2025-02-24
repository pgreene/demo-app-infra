locals {
    account_id = "358665735850"
    name = join("-",[local.env,local.prefix])
    region = "ca-central-1"
    env = "dev"
    prefix = "demo-app-vpc"
    creator = "terraform"
    owner = "pgreene"
    tags = {
        Environment = local.env
        Creator = local.creator
        Owner = local.owner
    }
    terraform_organization_id = "pgconsulting"
}
