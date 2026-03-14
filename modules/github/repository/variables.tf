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
    error_message = "Visibility must be either 'public', 'private', or 'internal'."
  }
}

variable "is_template" {
  description = "Whether this repository is a template repository"
  type        = bool
  default     = false
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
  default     = "apache-2.0"
  validation {
    condition     = var.visibility == "public" || trimspace(var.license_template) == "" || trimspace(var.license_template) == null
    error_message = "Visibility must be 'public' in order to apply a license template."
  }
}

variable "allow_merge_commit" {
  description = "Whether to allow merge commits when merging pull requests"
  type        = bool
  default     = false
}