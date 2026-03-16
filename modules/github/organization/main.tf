# ISO 27001/CIS compliance
resource "github_organization_settings" "settings" {
  billing_email = var.billing_email
  company       = var.company_name
  blog          = var.company_website
  email         = var.security_email
  name          = var.display_name
  description   = var.org_description
  location      = var.location

  has_organization_projects = true
  has_repository_projects   = false

  # ISO: Least Privilege - Prevent members from creating public repos
  members_can_create_repositories          = false
  members_can_create_public_repositories   = false
  members_can_create_private_repositories  = false
  members_can_create_internal_repositories = false
  members_can_create_pages                 = false
  members_can_create_public_pages          = false
  members_can_create_private_pages         = false

  # Prevent forks of private repositories (Data Loss Prevention)
  members_can_fork_private_repositories = false

  # Use teams to grant access
  default_repository_permission = "none"

  # Prever gitsign or GPG
  web_commit_signoff_required = false
}

data "github_organization" "this" {
  name       = var.github_org_login
}

# 2FA can only be enforced on GitHub UI
check "enforce_2fa_compliance" {
  assert {
    condition     = data.github_organization.this.two_factor_requirement_enabled == true
    error_message = "CIS COMPLIANCE VIOLATION: Two-factor authentication is disabled. An org admin must enable it in the GitHub UI before this pipeline can proceed."
  }
}