locals {
    account_id = "358665735850"
    name = join("-",[local.env,local.prefix])
    region = "ca-central-1"
    env = "dev"
    prefix = "demo-app-ecs"
    creator = "terraform"
    owner = "pgreene"
    port = "80"
    secure_port = "443"
    namespace_id = module.sd_private_dns.id
    tags = {
        Name = local.name
        Environment = local.env
        Creator = local.creator
        Owner = local.owner
    }
    terraform_organization_id = "pgconsulting"
}
