variable "naming_convention" {
  type        = string
  description = "Name of the Team resources are provisioned for"
}

variable "resource_group" {
  type        = string
  description = "Name of the Team resources are provisioned for"
}

variable "vmsize" {
  default = "Standard_B1ls"
  description = "Size of the Virtual Machine"
}

variable "vmname" {
  type = string
  description = "Name of the virtual machine"
}

variable "subnet_id" {
  type = string
}