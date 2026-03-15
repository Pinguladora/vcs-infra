globals {
  github_owner            = "Pinguladora"
  github_provider_version = "6.11.1"
  repo_visibility         = "private"
}

# OpenTofu and provider versions
generate_hcl "_terramate_generated_versions.tf" {
  content {
    terraform {
      required_version = global.opentofu_version
      required_providers {
        github = {
          source  = "integrations/github"
          version = global.github_provider_version
        }
        terraform = {
          source = "terraform.io/builtin/terraform"
        }
      }
    }
  }
}

# Providers
generate_hcl "_terramate_generated_providers.tf" {
  content {
    provider "github" {
      owner            = global.github_owner
      max_retries      = 3
      retryable_errors = [500, 502, 503, 504]
    }
  }
}