# Globale Test-Variablen definieren
variables {
  project     = "myproject"
  environment = "dev"
  cost_center = "CC-4321"
}

# ------------------------------------------------------------------
# TEST 1: Passt die Naming-governance und werden die Tags gebaut?
# ------------------------------------------------------------------
run "verify_naming_convention_and_tags" {
  command = plan

  assert {
    condition     = output.resource_group_name == "rg-myproject-dev-001"
    error_message = "Der generierte Resource-Group-Name entspricht nicht der Naming-Convention!"
  }

  assert {
    condition     = output.tags["CostCenter"] == "CC-4321"
    error_message = "Das Tag 'CostCenter' wurde nicht korrekt übernommen."
  }

  assert {
    condition     = output.tags["ManagedBy"] == "Terraform"
    error_message = "Das Pflicht-Tag 'ManagedBy' fehlt!"
  }
}

# ------------------------------------------------------------------
# TEST 2: Reagiert die Pipeline bei einer ungültigen Kostenstelle?
# ------------------------------------------------------------------
run "reject_invalid_cost_center" {
  command = plan

  variables {
    cost_center = "FALSCH-123" # Passt nicht auf ^CC-[0-9]{4}$
  }

  # Wir erwarten explizit, dass var.cost_center blockiert wird
  expect_failures = [
    var.cost_center
  ]
}
