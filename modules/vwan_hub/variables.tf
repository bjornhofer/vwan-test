variable "resource_group" {
  type        = string
  description = "Name of the Team resources are provisioned for"
}

variable "vwan_id" {
  type        = string
  description = "Name of the Virtual WAN"
}

variable "vwan_hub_region" {
  type        = string
  description = "Region of the Virtual WAN Hub"
}

variable "vwan_hub_ip" {
  type = string
  description = "IP-scope of the Virtual WAN Hub"
}

variable "loganalytics_workspace_id" {
  type = string
  description = "ID of LogAnalytics Workspace"
}