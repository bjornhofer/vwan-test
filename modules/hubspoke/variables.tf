variable "resource_group" {
  type        = string
  description = "'Resource Group'"
}

variable "hub_scope" {
  type        = string
  description = "IP Scope of the VNET"
}

variable "hub_subnet_scope" {
  type        = string
  description = "IP Scope of the VNET"
}

variable "spoke_scope" {
  type        = string
  description = "IP Scope of the VNET"
}

variable "spoke_subnet_scope" {
  type        = string
  description = "IP Scope of the VNET"
}

