output "resource_group_name" {
  description = "Der generierte Name der Resource Group"
  value       = local.resource_group_name
}

output "tags" {
  description = "Die standardisierten Enterprise-Tags"
  value       = local.mandatory_tags
}
