variable "resource_group" {
  type        = string
  description = "'Resource Group'"
}

variable "vnet_scope" {
  type        = string
  description = "IP Scope of the VNET"
}

variable "subnet_prefix" {
  type        = string
  description = "IP prefix of the subnet"
}

variable "vwan_hub_id" {
  type        = string
  description = "ID of the VWAN Hub"
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  default     = false
  description = "enable or disable private endpoints"
}