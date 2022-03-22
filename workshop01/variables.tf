variable "DO_token" {
  type        = string
  sensitive   = true
  description = "Access token for Digital Ocean"
}

variable "num_container" {
  type        = number
  default     = 3
  description = "Number of docker containers"
}

variable "INSTANCE_NAME" {
  type        = string
  default     = "dov"
  description = "Name of application running inside container"
}
