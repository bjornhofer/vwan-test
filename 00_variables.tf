######################################################
# VARIABLES
######################################################

variable "PROJECT" {
  type = string
  description = "Name of the project"
}

variable "STAGE" {
    type = string
    description = "Name of the stage"
}

variable "LOCATION" {
    default = "West Europe"
    description = "Azure Location"
}

variable "STAGE_NUMBER" {
    type = string
    description = "Number to distingish versioning between same stages"
}