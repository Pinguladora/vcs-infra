// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

provider "github" {
  max_retries = 3
  owner       = "Pinguladora"
  retryable_errors = [
    500,
    502,
    503,
    504,
  ]
}
