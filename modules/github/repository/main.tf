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
  archive_on_destroy = true

  # GitHub Pages
  pages {
    build_type = "workflow"
    source {
      branch = "main"
      path   = "/docs/website"
    }
  }

  # Security
  vulnerability_alerts = true
  ## Advanced Security only for public repos
  security_and_analysis {
    advanced_security {
      status = var.visibility == "public" ? "enabled" : "disabled"
    }
    code_security {
      status = var.visibility == "public" ? "enabled" : "disabled"
    }
    secret_scanning {
      status = var.visibility == "public" ? "enabled" : "disabled"
    }
    secret_scanning_push_protection {
      status = var.visibility == "public" ? "enabled" : "disabled"
    }
    secret_scanning_ai_detection {
      status = var.visibility == "public" ? "enabled" : "disabled"
    }
    secret_scanning_non_provider_patterns {
      status = var.visibility == "public" ? "enabled" : "disabled"
    }
  }
}

# Trunk Based Development (TBD)
resource "github_branch_default" "default" {
  repository = github_repository.this.node_id
  branch     = "main"
}

# CIS Requirement, enforce Branch Protection on default branch
resource "github_branch_protection" "default" {
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
