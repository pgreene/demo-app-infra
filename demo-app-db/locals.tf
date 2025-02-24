locals {
    account_id = "358665735850"
    name = join("-",[local.env,local.prefix])
    region = "ca-central-1"
    env = "dev"
    prefix = "demo-app-db"
    creator = "terraform"
    owner = "pgreene"
    db_username = "demoapp"
    tags = {
        Name = local.name
        Environment = local.env
        Creator = local.creator
        Owner = local.owner
    }
    terraform_organization_id = "pgconsulting"
}
