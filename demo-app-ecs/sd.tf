
module "sd_private_dns" {
  source = "app.terraform.io/pgconsulting/service-discovery-private-dns-namespace/aws"
  version = "1.0.0"
  name = local.name 
  description = "Service Discovery"
  tags = local.tags
  vpc_id = data.aws_vpc.selected.id
}

module "sd_service" {
  source = "app.terraform.io/pgconsulting/service-discovery/aws"
  version = "1.0.0"
  name = "demo-app"
  description = "Service Discovery"
  namespace_id = module.sd_private_dns.id
  #use_dns_config = true
  dns_config = {
    namespace_id = module.sd_private_dns.id
    routing_policy = "MULTIVALUE"
  dns_records = {
      ttl = 60
      type = "A"
    }
  }

  health_check_config = null
  #health_check_custom_config = {
  #  failure_threshold = 2
  #}
  health_check_custom_config = null
  
  tags = local.tags
}
