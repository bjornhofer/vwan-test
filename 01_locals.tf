##################################################################################
# Locals
##################################################################################

locals {
  # replace empty strings with dashes, to be used as git repo names
    project             = lower(replace(var.PROJECT, " ", "-"))
    stage               = lower(var.STAGE)
    stage_number        = lower(var.STAGE_NUMBER)
    location            = lower(var.LOCATION)
    naming_convention   = "${local.project}-${local.stage}-${local.stage_number}"
}