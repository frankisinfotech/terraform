# Define availability zones
variable "availability_zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "eks_cluster" {
  type     = string
  default  = "saha-sandbox-qa-cluster"
}
