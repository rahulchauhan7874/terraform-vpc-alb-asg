variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
  default     = "10.0.0.0/16" #65,536 IPs

}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.0/20", "10.0.16.0/20"] #4096 IPs
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.128.0/20", "10.0.144.0/20"] #4096 IPs
}

variable "us_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}