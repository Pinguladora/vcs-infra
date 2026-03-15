// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "repository" {
  description   = "Repository for Alpha project"
  name          = "web-app-alpha"
  owner_has_pro = "false"
  source        = "../../../../../modules/github/repository"
  topics = [
    "alpha",
    "golang",
    "tofu",
  ]
  visibility = "public"
}
