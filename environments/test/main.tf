terraform {
  required_version = ">= 1.5.0"

  # Wir nutzen das lokale Backend, um keine Cloud-Anbindung zu benötigen
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

# Eine normale, sichere Datei
resource "local_file" "welcome_message" {
  filename = "${path.module}/welcome.txt"
  content  = "Hallo Plattform-Team! Diese Datei wurde via GitHub Actions deployt."
}

# --- DIESE RESSOURCE TRIGGERED DEN SECURITY-WARN ---
# tfsec wird meckern, weil die Rechte (0777) viel zu locker sind.
resource "local_file" "sensitive_data" {
  filename        = "${path.module}/secret.txt"
  content         = "Das ist ein simuliertes Passwort!"
  file_permission = "0777"
}

resource "local_file" "sensitive_data2" {
  filename        = "${path.module}/secret2.txt"
  content         = "Das ist ein simuliertes Passwort!"
  file_permission = "0777"
}
