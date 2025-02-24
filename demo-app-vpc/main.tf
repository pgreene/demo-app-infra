module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = local.name
  cidr = "20.10.0.0/16"

  azs = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  private_subnets = ["20.10.0.0/20", "20.10.32.0/20", "20.10.64.0/20"]
  public_subnets = ["20.10.96.0/20","20.10.128.0/20", "20.10.160.0/20"]
  enable_ipv6 = true
  private_subnet_enable_dns64 = false
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false
  public_subnet_assign_ipv6_address_on_creation = true
  private_subnet_assign_ipv6_address_on_creation = false
  public_subnet_ipv6_prefixes = [0, 1, 2]
  #private_subnet_ipv6_prefixes = [3,4, 5, 6, 7]
  create_database_subnet_group = true
  create_elasticache_subnet_group = true
  enable_dns_hostnames = true
  enable_dns_support = true
  database_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

# ------------------------------------------------- #
# --- ACL SETTINGS -------------------------------- #
# ------------------------------------------------- #
  default_network_acl_name = join("-",[local.prefix,"default-acl"])
  public_dedicated_network_acl = true
  private_dedicated_network_acl = false
  manage_default_network_acl = true
# ------------------------------------------------- #

# ------------------------------------------------- #
# --- NAT GATEWAY OPTIONS ------------------------- #
# ------------------------------------------------- #
  # Single NAT Gateway (for all subnets)
  enable_nat_gateway = true 
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  tags = local.tags
  igw_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"igw"])}))
  public_subnet_tags = merge(local.tags,tomap({Name = join("-",[local.name,"public"])}))
  private_subnet_tags = merge(local.tags,tomap({Name = join("-",[local.name,"private"])}))
  public_route_table_tags = local.tags
  private_route_table_tags = local.tags
  public_acl_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"public-acl"])}))
  private_acl_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"private-acl"])}))
  database_subnet_group_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"db-sbg"])}))
  dhcp_options_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"dhcp"])}))
  nat_gateway_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"ngw"])}))
  nat_eip_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"eip"])}))
  default_network_acl_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"default-acl"])}))
  customer_gateway_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"cgw"])}))
  redshift_subnet_group_tags = merge(local.tags,tomap({Name = join("-",[local.prefix,"rs-sbg"])}))
}