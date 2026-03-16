variable "display_name" {
  description = "The organization's display name"
  type        = string
}

variable "github_org_login" {
  description = "The organization's login (slug used in URL, e.g. 'acme-corp')"
  type        = string
}

variable "org_description" {
  description = "The organization's description"
  type        = string
}

variable "billing_email" {
  description = "Billing email for the organization"
  type        = string
}

variable "security_email" {
  description = "Security contact email for the organization"
  type        = string
}

variable "company_name" {
  description = "Legal name of the company"
  type        = string
}

variable "company_website" {
  description = "Company website URL"
  type        = string
}

variable "members" {
  description = "List of organization members and their roles"
  type = list(object({
    username = string
    role     = string
  }))
  default = []
}

variable "location" {
  description = "Location of the organziation"
  type        = string
  default     = "Earth"
}

variable "github_token" {
  description = "GitHub Token (App or PAT) used for API calls outside the standard provider scope"
  type        = string
  sensitive   = true
}