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
  
  variable "igw_tags" {

  default = {}
  
}

variable "public_subnet_cidr" {
    type = list 
    
    validation {
      condition = length(var.public_subnet_cidr) == 2
      error_message = "please provide 2 valid subnet cidr"


    }
  
}

variable "public_subnet_tags" {
    default = {}
  

}


variable "private_subnet_cidr" {
    type = list 
    
    validation {
      condition = length(var.private_subnet_cidr) == 2
      error_message = "please provide 2 valid subnet cidr"


    }
  
}

variable "private_subnet_tags" {
    default = {}
  

}

variable "database_subnet_cidr" {
    type = list 
    
    validation {
      condition = length(var.database_subnet_cidr) == 2
      error_message = "please provide 2 valid subnet cidr"


    }
  
}

variable "database_subnet_tags" {
    default = {}
  

}


variable "db_subnet_group_tags" {

    default = {}
  
}

variable "aws_nat_gateway_tags" {

  default = {}
  
}

variable "public_route_table_tags" {

  default = {}
  
}

variable "private_route_table_tags" {

  default = {}
  
}

variable "database_route_table_tags" {

  default = {}
  
}

