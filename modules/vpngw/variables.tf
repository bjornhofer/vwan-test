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

variable "branch_asn" {
  type = string
  description = "ASN of the branch"
}

variable "vwan_hub_id" {
  type = string
  description = "ID of the VWAN Hub"
}

variable "shared_key" {
  type = string
  description = "Shared Key for the P2S connection"
}