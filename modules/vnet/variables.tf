variable "name" {
  type        = string
  description = "Name of the Team resources are provisioned for"
}

variable "resource_group" {
  type        = string
  description = "Name of the Team resources are provisioned for"
}

variable "vnet_address_scope" {
  type        = string
  description = "Adress Space of VNET"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Prefix of the subnet"
}

variable "subnet_vpn_address_prefix" {
  type = string
  description = "Prefix of the VPN subnet"
} 