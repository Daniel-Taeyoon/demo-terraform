variable "cidr_block" {
  type        = map(string)
  description = "VPN CIDR value"
  default     = {
    "develop" : "10.12.0.0/16"
    "stage" : "10.22.0.0/16"
    "main" : "10.32.0.0/16"
  }
}

variable "environment_upper" {
  type = map(string)
  default = {
    "develop" : "DEV"
    "stage" : "STG"
    "main" : "PRD"
  }
}

variable "environment_lower" {
  type = map(string)
  default = {
    "develop" : "dev"
    "stage" : "stg"
    "main" : "prd"
  }
}

variable "public_subnet_cidrs" {
  type        = map(list(string))
  description = "Public Subnet CIDR values"
  default     = {
    "develop" : ["10.12.0.0/24", "10.12.8.0/24"]
    "stage" : ["10.22.0.0/24", "10.22.8.0/24"]
    "main" : ["10.32.0.0/24", "10.32.8.0/24"]
  }
}

#variable "private_subnet_cidrs" {
#  type        = list(string)
#  description = "Private Subnet CIDR values"
#  default     = ["10.10.16.0/24", "10.10.20.0/24"]
#}

variable "ecs_subnet_cidrs" {
  type        = map(list(string))
  description = "Data Subnet CIDR values"
  default     = {
    "develop" : ["10.12.24.0/24", "10.12.32.0/24"]
    "stage" : ["10.22.24.0/24", "10.22.32.0/24"]
    "main" : ["10.32.24.0/24", "10.32.32.0/24"]
  }
}

variable "data_subnet_cidrs" {
  type        = map(list(string))
  description = "Data Subnet CIDR values"
  default     = {
    "develop" : ["10.12.38.0/24", "10.12.40.0/24"]
    "stage" : ["10.22.38.0/24", "10.22.40.0/24"]
    "main" : ["10.32.38.0/24", "10.32.40.0/24"]
  }
}

variable "azs" {
  type        = map(list(string))
  description = "Availability Zone"
  default     = {
    "develop" : ["ap-northeast-2a", "ap-northeast-2c"]
    "stage" : ["ap-northeast-2a", "ap-northeast-2c"]
    "main" : ["ap-southeast-1a", "ap-southeast-1c"]
  }
}

variable "dex_region" {
  type = map(string)
  default = {
    "develop" : "ap-northeast-2"
    "stage" : "ap-northeast-2"
    "main" : "ap-southeast-1"
  }
}

