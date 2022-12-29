variable "cidr_block" {
  type        = string
  description = "VPN CIDR value"
  default     = ""
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = [""]
}

#variable "private_subnet_cidrs" {
#  type        = list(string)
#  description = "Private Subnet CIDR values"
#  default     = ["10.10.16.0/24", "10.10.20.0/24"]
#}

variable "ecs_subnet_cidrs" {
  type        = list(string)
  description = "Data Subnet CIDR values"
  default     = [""]
}

variable "data_subnet_cidrs" {
  type        = list(string)
  description = "Data Subnet CIDR values"
  default     = [""]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zone"
  default     = [""]
}