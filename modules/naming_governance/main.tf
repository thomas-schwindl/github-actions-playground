# main.tf

locals {
  # Naming-Convention: rg-<project>-<environment>-001
  resource_group_name = "rg-${var.project}-${var.environment}-001"

  # Standardisierte Enterprise-Tags
  mandatory_tags = {
    Environment = var.environment
    Project     = var.project
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
  }
}

