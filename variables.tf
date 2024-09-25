variable "vpc_cidr" {
  
}

variable "enable_dns_hostnames" {
  default = true
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  default = {}
}

variable "vpc_tags" {
    default = {}
    }
  
