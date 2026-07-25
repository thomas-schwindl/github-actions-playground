# ==============================================================================
# EINGABE-VARIABLEN: AWS NAMING CONVENTION
# ==============================================================================

variable "project_name" {
  type        = string
  description = <<EOT
Name des Projekts oder der Anwendung (z. B. 'my-app' oder 'PaymentService').
Wird im Modul automatisch bereinigt (Kleinbuchstaben, Sonderzeichen -> '-').
EOT

  validation {
    # Stellt sicher, dass kein leerer String "" übergeben wird
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "Der Projektname darf nicht leer sein oder nur aus Leerzeichen bestehen."
  }
}

variable "environment" {
  type        = string
  description = "Zielumgebung für die AWS-Ressource. Erlaubt: 'dev', 'stage', 'prod'."

  validation {
    # Whitelist-Check: Verhindert Tippfehler wie 'development' oder 'staging'
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Ungültige Umgebung! Erlaubte Werte sind ausschließlich: 'dev', 'stage', 'prod'."
  }
}

variable "account_id" {
  type        = string
  description = <<EOT
Die 12-stellige AWS Account ID (z. B. '123456789012').
Wird an den S3-Bucket-Namen angehängt, um weltweite Eindeutigkeit zu garantieren.
EOT
  default     = "123456789012"

  validation {
    # Regex-Check: Erzwingt exakt 12 aufeinanderfolgende Ziffern (0-9)
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "Die AWS Account ID muss aus genau 12 Ziffern bestehen (ohne Bindestriche oder Leerzeichen)."
  }
}
