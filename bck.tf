# Create the Org (Requires Enterprise Admin Token)
# resource "github_enterprise_organization" "this" {
#   enterprise_id = var.enterprise_id
#   name          = var.org_name
#   admin_logins  = var.admin_logins
#   billing_email = var.billing_email
# }

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

resource "terraform_data" "enforce_2fa" {
  # This triggers the API call whenever the organization name changes or upon initial creation
  # Use the organization login (slug), NOT the display name due to spaces
  triggers_replace = [var.github_org_login]

  provisioner "local-exec" {
    # command = <<EOT
    #   curl -L -S -s \
    #     -X PATCH \
    #     -H "Accept: application/vnd.github+json" \
    #     -H "Authorization: Bearer ${var.github_token}" \
    #     -H "X-GitHub-Api-Version: ${var.github_api_version}" \
    #     "https://api.github.com/orgs/${var.display_name}" \
    #     -d '{"two_factor_requirement_enabled": true}'
    # --header \"Host: api.github.com:443\"
    # EOT
    command = "gh api --method PATCH orgs/${var.github_org_login} -F two_factor_requirement_enabled=true"
  }

  # Ensure the org exists (or is being managed) before trying to patch it
  depends_on = [
    github_organization_settings.settings
  ]
}

# Failsafe check: ensures the API call worked and no one disabled it manually later
data "github_organization" "this" {
  # name = var.display_name
  name       = var.github_org_login
  depends_on = [terraform_data.enforce_2fa]
}

# 2FA can only be enforced on GitHub UI
check "enforce_2fa_compliance" {
  assert {
    condition     = data.github_organization.this.two_factor_requirement_enabled == true
    error_message = "CIS COMPLIANCE VIOLATION: Two-factor authentication is disabled. An org admin must enable it in the GitHub UI before this pipeline can proceed."
  }
}

# Manage Organization Members
# resource "github_membership" "members" {
#   for_each = { for m in var.members : m.username => m }

#   username             = each.value.username
#   role                 = each.value.role # 'admin' or 'member'
#   downgrade_on_destroy = false
# }

variable "github_api_version" {
  description = "GitHub API version"
  type        = string
  default     = "2026-03-10"
}

# output "active_members" {
#   value = [for m in github_membership.members : m.username]
# }