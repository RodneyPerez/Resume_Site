variable "www_domain_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "secret" {
  type = string
}

variable "main_tags" {
  type = map(string)
}

variable "redirect_tags" {
  type = map(string)
}

