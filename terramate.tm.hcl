terramate {
  required_version = "~> 0.16.0"
  config {
    generate {
      hcl_magic_header_comment_style = "//"
    }
  }
}

globals {
  opentofu_version = "1.11.5" # Enforce OpenTofu version across all stacks
  modules_root     = "${terramate.stack.path.to_root}/modules"
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "local" {}
    }
  }
}