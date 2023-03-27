variable "region" {
  type    = string
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "name_public_subnet" {
  type = string
}

variable "name_private_subnet" {
  type = string
}