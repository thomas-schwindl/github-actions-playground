# ==============================================================================
# OUTPUTS: EXPORTIERTE WERTE DES MODULS
# ==============================================================================

output "s3_bucket_name" {
  description = "Der finale, bereinigte und AWS-konforme Name für den S3-Bucket."
  value       = local.bucket_name
}

output "bucket_name_length" {
  description = "Die Zeichenlänge des generierten S3-Bucket-Namens (max. 63 Zeichen)."
  value       = length(local.bucket_name)
}
