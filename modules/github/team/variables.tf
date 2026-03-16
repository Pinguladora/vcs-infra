variable "name" {
  description = "The name of the team"
  type        = string
}

variable "description" {
  description = "A description of what this team does"
  type        = string
  default     = "Managed by Platform Engineering"
}

variable "privacy" {
  description = "Level of privacy (closed or secret). Default is closed (visible to org members)."
  type        = string
  default     = "closed"
}

variable "users" {
  description = "Map of usernames to roles (member or maintainer)"
  type        = map(string)
  default     = {}
}

variable "repositories" {
  description = "Map of repository names to permission levels (pull, push, maintain, admin)"
  type        = map(string)
  default     = {}
}