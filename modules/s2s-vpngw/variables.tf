variable "resource_group" {
  type        = string
  description = "Name of the Team resources are provisioned for"
}

variable "vnet_address_scope" {
  type = string
  description = "ASN of the branch"
}
variable "subnet_address_prefix" {
  type = string
  description = "ASN of the branch"
}

variable "subnet_vpn_address_prefix" {
  type = string
  description = "ASN of the branch"
}

variable "hub_vpn_ip" {
  type = string
  description = "IP of the Hub-VPNGW"
}

variable "branch_asn" {
  type = string
  description = "ASN of the branch"
}

variable "shared_key" {
  type = string
  description = "Shared Key for the P2S connection"
}