############################################################################
# Deploy API Gateway with VPC, Subnet, Route Table and Security Group
############################################################################

resource "opentelekomcloud_networking_secgroup_v2" "secgroup_1" {
  name                 = format("%s_%s", var.prefix, "secgroup-1")
  description          = format("Security Group %s_%s", var.prefix, "secgroup-1")
  region               = var.OTC_SDK_REGION
  delete_default_rules = true
  tenant_id            = var.OTC_SDK_PROJECTID
  timeouts {}

}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_ingress_ipv4" {
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "tcp"
  port_range_min = 80
  port_range_max = 80
  #remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  tenant_id         = var.OTC_SDK_PROJECTID
  description       = "Allow incomming traffic on port 80"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_ingress_ipv4_443" {
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "tcp"
  port_range_min = 443
  port_range_max = 443
  #remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  tenant_id         = var.OTC_SDK_PROJECTID
  description       = "Allow incomming traffic on port 443"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_ingress_ipv6" {
  direction      = "ingress"
  ethertype      = "IPv6"
  protocol       = "tcp"
  port_range_min = 80
  port_range_max = 80
  #remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  tenant_id         = var.OTC_SDK_PROJECTID
  description       = "Allow incomming traffic on port 80"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_ingress_ipv6_443" {
  direction      = "ingress"
  ethertype      = "IPv6"
  protocol       = "tcp"
  port_range_min = 443
  port_range_max = 443
  #remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  tenant_id         = var.OTC_SDK_PROJECTID
  description       = "Allow incomming traffic on port 443"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  tenant_id         = var.OTC_SDK_PROJECTID
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  tenant_id         = var.OTC_SDK_PROJECTID
}

resource "opentelekomcloud_vpc_route_table_v1" "table_1" {
  name        = format("%s_%s", var.prefix, "rtb-vpc-1")
  vpc_id      = opentelekomcloud_vpc_v1.vpc_v1.id
  description = ""
  subnets = [
    opentelekomcloud_vpc_subnet_v1.subnet_v1.id
  ]
  timeouts {}

}

resource "opentelekomcloud_vpc_subnet_v1" "subnet_v1" {
  name = format("%s_%s", var.prefix, "subnet-1")

  availability_zone = format("%s-01", var.OTC_SDK_REGION)
  cidr              = "192.168.0.0/24"
  dhcp_enable       = true
  ipv6_enable       = false

  vpc_id = opentelekomcloud_vpc_v1.vpc_v1.id

  gateway_ip = "192.168.0.1"

  dns_list = [
    "100.125.4.25",
    "100.125.129.199"
  ]

  timeouts {}

}

resource "opentelekomcloud_vpc_v1" "vpc_v1" {
  cidr        = "192.168.0.0/16"
  description = ""
  name        = format("%s_%s", var.prefix, "vpc-1")
  region      = var.OTC_SDK_REGION
}


resource "opentelekomcloud_apigw_gateway_v2" "gateway" {

  availability_zones              = [format("%s-01", var.OTC_SDK_REGION)]
  bandwidth_size                  = 5
  ingress_bandwidth_charging_mode = "bandwidth"
  ingress_bandwidth_size          = 5
  loadbalancer_provider           = "elb"
  maintain_begin                  = "22:00:00"
  name                            = format("%s_%s", var.prefix, "apig-1")

  security_group_id = opentelekomcloud_networking_secgroup_v2.secgroup_1.id
  spec_id           = "BASIC"

  subnet_id = opentelekomcloud_vpc_subnet_v1.subnet_v1.id

  timeouts {
    create = null
    delete = null
    update = null
  }

  vpc_id = opentelekomcloud_vpc_v1.vpc_v1.id

}
