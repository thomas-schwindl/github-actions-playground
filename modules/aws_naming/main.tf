# ==============================================================================
# LOGIK: BEREINIGUNG UND NAMENSGENERIERUNG FÜR AWS S3 BUCKETS
# ==============================================================================
# AWS S3 Richtlinien:
# 1. 3 bis 63 Zeichen lang.
# 2. Nur Kleinbuchstaben, Zahlen, Bindestriche (-) und Punkte (.).
# 3. Darf nicht mit einem Bindestrich beginnen oder enden.
# 4. Keine fortlaufenden Bindestriche (--) oder Kombinationen.
# ==============================================================================

locals {
  # Schritt 1: In Kleinbuchstaben umwandeln & unzulässige Zeichen durch "-" ersetzen
  # Beispiel: "Super_Cool--App!" -> "super-cool--app-"
  clean_project_raw = replace(lower(var.project_name), "/[^a-z0-9-]/", "-")

  # Schritt 2: Doppelte Bindestriche (--) zusammenfassen & Ränder säubern
  # - replace(..., "/-+/", "-") macht aus "--" ein einzelnes "-"
  # - trim(..., "-") entfernt "-" am Anfang oder Ende des Strings
  clean_project = trim(replace(local.clean_project_raw, "/-+/", "-"), "-")

  # Schritt 3: Den vollständigen Namen gemäß Konvention zusammensetzen
  # Schema: s3-<projekt>-<env>-<account_id>
  raw_bucket_name = "s3-${local.clean_project}-${var.environment}-${var.account_id}"

  # Schritt 4: Hartes Limit von 63 Zeichen durchsetzen
  # Falls der String gekürzt wird, stellen wir sicher, dass am Ende kein "-" stehen bleibt
  bucket_name = trim(substr(local.raw_bucket_name, 0, 63), "-")
}
