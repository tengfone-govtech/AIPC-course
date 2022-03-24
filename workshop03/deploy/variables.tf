variable "DO_token" {
  type        = string
  sensitive   = true
  description = "Access token for Digital Ocean"
}

variable "private_key" {
  type      = string
  sensitive = true
}

variable "code_server_password"{
  type = string
  sensitive = true
}