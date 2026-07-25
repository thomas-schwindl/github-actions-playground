# variables.tf

variable "project" {
  type        = string
  description = "Name des Projekts (3 bis 10 Zeichen, nur Kleinbuchstaben)"

  validation {
    condition     = can(regex("^[a-z0-9]{3,10}$", var.project))
    error_message = "Der Projektname muss zwischen 3 und 10 Zeichen lang sein und darf nur Kleinbuchstaben/Zahlen enthalten."
  }
}

variable "environment" {
  type        = string
  description = "Zielumgebung"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment muss 'dev', 'stage' oder 'prod' sein."
  }
}

variable "cost_center" {
  type        = string
  description = "Kostenstelle für das Billing (z.B. CC-1234)"

  validation {
    condition     = can(regex("^CC-[0-9]{4}$", var.cost_center))
    error_message = "Kostenstelle muss dem Format 'CC-1234' entsprechen."
  }
}
