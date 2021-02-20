
variable "vpcCIDR" {
    description = "The CIDR block used for subnets in the tailscale VPC"
    type = string
    default = "10.255.0.0/16"
}

variable "externalCIDRs" {
    description = "A list of CIDR blocks external to the VPC used to manage the hypo VPN"
    type = list(string)
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "availabilityZones" {
  description = "number of AZ to use when building the cluster."
  type        = number
  default     = 1
}

variable "name" {
  description = "The name of the relay vpn"
  type    = string
  default = "seed"
}

variable "public_key" {
  description = "public key to use on the tailscale relay"
  type = string
}

variable "auth_key" {
  description = "auth key for tailscale"
  type = string 
}


variable "allow_aah" {
  description = "Enabled/Disable SSH access from external CIDRs"
  type = bool
  default = true
}
