stack {
  name        = "vcs-infra"
  description = "This very repo stack"
  tags        = ["github", "repo", "repository", "vcs"]
  id          = "4f6446e7-d589-4e6b-9d95-02252a7bbb92"
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "repository" {
      # Avoids hell like "../../../../../modules/github/repository"
      source        = "${terramate.stack.path.to_root}/modules/github/repository"
      name          = "vcs-infra"
      description   = "IaC for VCS providers"
      visibility    = "public"
      owner_has_pro = "false"
      topics        = ["opentofu", "tofu", "terramate"]
    }
  }
}