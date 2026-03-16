# Teams ONLY exists within an organization

# Fetch the user's current Org membership status.
# IF the user is NOT in the organization, it fails.
data "github_membership" "member" {
  for_each = var.users

  username = each.key
}

resource "github_team" "this" {
  name        = var.name
  description = var.description
  privacy     = var.privacy
}

resource "github_team_membership" "this" {
  for_each = var.users

  team_id  = github_team.this.id
  username = each.key

  # Auto-correct role, to avoid perpetual diff (Second note on https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_membership)
  # If user is an Org Owner ("admin"), force their team role to "maintainer".
  # Otherwise, respect the role requested in the variable.
  role = data.github_membership.member[each.key].role == "admin" ? "maintainer" : each.value # 'member' or 'maintainer'
}

# Grant the team access to specific repositories
resource "github_team_repository" "this" {
  for_each = var.repositories

  team_id    = github_team.this.id
  repository = each.key
  permission = each.value
}