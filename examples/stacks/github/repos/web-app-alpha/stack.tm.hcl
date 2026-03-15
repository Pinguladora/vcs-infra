stack {
  name        = "web-app-alpha"
  description = "Web alpha stack"
  id          = "b23fa8e0-8ce2-457b-97fe-6fafc180bdf1"
  tags        = ["vcs", "github", "repository", "repo"]
}


generate_hcl "_terramate_generated_main.tf" {
  content {
    module "repository" {
      # Avoids hell like "../../../../../modules/github/repository"
      source        = "${terramate.stack.path.to_root}/modules/github/repository"
      name          = "web-app-alpha"
      description   = "Repository for Alpha project"
      visibility    = "public"
      owner_has_pro = "false"
      topics        = ["alpha", "golang", "tofu"]
    }
  }
}