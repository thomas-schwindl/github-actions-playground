# modules/aws_naming/tests/bucket.tftest.hcl

# ------------------------------------------------------------------
# TEST 1: Standard S3-Naming prüfen
# ------------------------------------------------------------------
run "verify_standard_s3_name" {
  command = plan

  variables {
    project_name = "my-app"
    environment  = "dev"
    account_id   = "112233445566"
  }

  assert {
    condition     = output.s3_bucket_name == "s3-my-app-dev-112233445566"
    error_message = "Der S3 Bucket Name entspricht nicht dem erwarteten Format!"
  }
}

# ------------------------------------------------------------------
# TEST 2: Härtetest - Falsche Zeichen, doppelte Bindestriche & zu lang
# ------------------------------------------------------------------
run "verify_complex_edge_cases" {
  command = plan

  variables {
    # Projektname mit Großbuchstaben, Sonderzeichen und extremer Länge
    project_name = "Super_Cool--App#With!!!Extremely-Long-Name-That-Exceeds-AWS-Limits"
    environment  = "prod"
    account_id   = "998877665544"
  }

  # Check A: Maximal 63 Zeichen
  assert {
    condition     = output.bucket_name_length <= 63
    error_message = "Bucket Name überschreitet das AWS Limit von 63 Zeichen!"
  }

  # Check B: Keine Sonderzeichen ausser Bindestrichen, keine doppelte "-"
  assert {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", output.s3_bucket_name))
    error_message = "Der generierte Name enthält ungültige AWS S3 Zeichen oder endet/startet mit einem Bindestrich!"
  }
}

# ------------------------------------------------------------------
# TEST 3: Ungültige AWS Account ID (muss genau 12 Zahlen haben)
# ------------------------------------------------------------------
run "reject_invalid_account_id" {
  command = plan

  variables {
    project_name = "test"
    environment  = "dev"
    account_id   = "123" # Zu kurz!
  }

  expect_failures = [
    var.account_id
  ]
}
