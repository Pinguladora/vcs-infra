output "org_id" {
  value = github_organization_settings.settings.id
}

output "org_name" {
  description = "The name of the configured organization"
  value       = github_organization_settings.settings.name
}