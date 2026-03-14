variable "owner_has_pro" {
  description = "Set true if the repo owner has GitHub Pro, Teams or Enterprise plan allowing private branch protection."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "description" {
  description = "A description of the repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Can be 'public', 'private', 'internal' (only Enterprise organization). Defaults to 'private'"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be either 'public', 'private', or 'internal' if it is within an Enterprise organization."
  }
}

variable "enable_pages" {
  description = "Whether to activate GitHub Pages"
  type        = bool
  default     = false
}

variable "is_template" {
  description = "Whether this repository is a template repository"
  type        = bool
  default     = false
}

variable "template_owner" {
  description = "Name of owner (user or organization) for the repository"
  type        = string
  default     = null
  validation {
    condition     = !var.is_template || trimspace(var.template_owner) == "" || trimspace(var.template_owner) == null
    error_message = "Owner must be specified when creating a template repo"
  }
}

variable "topics" {
  description = "A list of GitHub topics to apply to the repository"
  type        = list(string)
  default     = []
}

variable "auto_init" {
  description = "Whether to create an initial commit in the repository"
  type        = bool
  default     = true
}

variable "gitignore_template" {
  description = "The name of the .gitignore template to apply when creating the repository. See https://https://github.com/github/gitignore for available templates."
  type        = string
  default     = ""
}

variable "license_template" {
  description = "The name of the license template to apply when creating the repository. See https://github.com/github/choosealicense.com/tree/gh-pages/_licenses for available templates."
  type        = string
  default     = ""
  validation {
    condition     = var.visibility != "public" || trimspace(var.license_template) == "" || trimspace(var.license_template) == null
    error_message = "Visibility must be 'public' in order to apply a license template."
  }
}

variable "allow_merge_commit" {
  description = "Whether to allow merge commits when merging pull requests"
  type        = bool
  default     = false
}

variable "has_advanced_security" {
  description = "Whether there is a GitHub Advance Security license"
  type        = bool
  default     = false
}