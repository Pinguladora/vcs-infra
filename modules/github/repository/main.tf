resource "github_repository" "this" {
  name            = var.name
  description     = var.description
  visibility      = var.visibility
  has_issues      = true
  has_wiki        = false
  has_discussions = true
  is_template     = var.is_template
  topics          = var.topics

  # Init config
  auto_init          = true
  gitignore_template = var.gitignore_template != "" ? var.gitignore_template : null
  license_template   = var.license_template

  # Merging
  allow_update_branch         = true
  delete_branch_on_merge      = true
  allow_auto_merge            = true
  allow_rebase_merge          = true
  allow_merge_commit          = var.allow_merge_commit
  merge_commit_title          = "PR_TITLE"
  merge_commit_message        = "PR_BODY"
  allow_squash_merge          = true
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  # Archive
  archive_on_destroy = false

  # Template
  dynamic "template" {
    for_each = var.is_template ? [1] : []
    content {
      owner                = var.template_owner
      repository           = "${var.name}-template"
      include_all_branches = false
    }
  }

  # GitHub Pages
  dynamic "pages" {
    for_each = var.enable_pages ? [1] : []
    content {
      build_type = "workflow"
      source {
        branch = "main"
        path   = "/docs"
      }
    }
  }

  # Security
  vulnerability_alerts = true
  ## Advanced Security only for public repos
  dynamic "security_and_analysis" {
    for_each = (var.visibility != "public" && var.has_advanced_security) ? [1] : []
    content {
      advanced_security {
        status = "enabled"
      }
      code_security {
        status = "enabled"
      }
      secret_scanning {
        status = "enabled"
      }
      secret_scanning_push_protection {
        status = "enabled"
      }
      secret_scanning_ai_detection {
        status = "enabled"
      }
      secret_scanning_non_provider_patterns {
        status = "enabled"
      }
    }
  }
}

# Trunk Based Development (TBD)
resource "github_branch_default" "default" {
  repository = github_repository.this.name
  branch     = "main"
}

# CIS Requirement, enforce Branch Protection on default branch
# Private: only available on PRO, Team and Enterprise plans
resource "github_branch_protection" "default" {
  count               = (var.visibility == "public" || var.owner_has_pro) ? 1 : 0
  repository_id       = github_repository.this.node_id
  pattern             = "main"
  enforce_admins      = true
  allows_force_pushes = false
  allows_deletions    = false

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    require_last_push_approval      = true
    required_approving_review_count = 2
  }

  required_status_checks {
    strict = true # Ensures branches are up to date before merging
  }
}
