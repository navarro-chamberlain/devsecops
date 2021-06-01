variable "prefix" {
  description = "The Prefix used for all resources in this example"
  default     =  "EWM"
}

variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
  default     = "East US"
}

variable "create" {
  description = "Create Module, defaults to true."
  default     = true
}

variable "permissions" {
  description = "The Unix file permission to assign to the cert files (e.g. 0600). Defaults to \"0600\"."
  default     = "0600"
}
