output "namespace_id" {
    value = module.sd_private_dns.id
}

output "service_id" {
    value = module.sd_service.id
}

#output "namespace" {
#    value = data.aws_service_discovery_dns_namespace.general.id
#}