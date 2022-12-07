variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.10.0.0/24", "10.10.8.0/24"]
}

#variable "private_subnet_cidrs" {
#  type        = list(string)
#  description = "Private Subnet CIDR values"
#  default     = ["10.10.16.0/24", "10.10.20.0/24"]
#}

variable "ecs_subnet_cidrs" {
  type        = list(string)
  description = "Data Subnet CIDR values"
  default     = ["10.10.24.0/24", "10.10.32.0/24"]
}

variable "data_subnet_cidrs" {
  type        = list(string)
  description = "Data Subnet CIDR values"
  default     = ["10.10.36.0/24", "10.10.40.0/24"]
}