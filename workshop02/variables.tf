variable "DO_token" {
  type        = string
  sensitive   = true
  description = "Access token for Digital Ocean"
}

variable "private_key" {
  type      = string
  sensitive = true
}
