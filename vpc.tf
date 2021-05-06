resource "aws_vpc" "hypo_vpn_vpc" {
  cidr_block           = var.vpcCIDR
  instance_tenancy     = "default" 
  enable_dns_support   = true 
  enable_dns_hostnames = true
  tags = tomap(
    {"Name" = "terraform-hypovpn-${var.name}-vpc",}
  )
}

resource "aws_subnet" "hypo_vpn_subnet" {
  count = var.availabilityZones

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.255.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.hypo_vpn_vpc.id

  tags = tomap({"Name" = "terraform-hypovpn-${var.name}-subnet"})
}


resource "aws_internet_gateway" "hypo_vpn_igw" {
  vpc_id = aws_vpc.hypo_vpn_vpc.id

  tags = tomap({"Name" = "terraform-hypovpn-${var.name}-igw"}
  )
}

resource "aws_route_table" "hypo_vpn_rtb" {
  vpc_id = aws_vpc.hypo_vpn_vpc.id

    tags = tomap({"Name" = "terraform-hypovpn-${var.name}-rtb"})

}

resource "aws_route" "default_route" {
  route_table_id            = aws_route_table.hypo_vpn_rtb.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.hypo_vpn_igw.id
}

resource "aws_route_table_association" "hypo_vpn_rtb_assoc" {
  count = var.availabilityZones

  subnet_id      = aws_subnet.hypo_vpn_subnet.*.id[count.index]
  route_table_id = aws_route_table.hypo_vpn_rtb.id
}


resource "aws_security_group" "hypo_vpn_ssh_sg" {
  vpc_id       = aws_vpc.hypo_vpn_vpc.id
  name         = "External Access Security Group"
  description  = "Security group allowing SSH from External IPs"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.externalCIDRs
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = tomap({"Name"="terraform-hypovpn-${var.name}-sg"}) 
}

# resource "aws_security_group" "security_group_lab" {
#   vpc_id       = aws_vpc.hypo_vpn_vpc.id
#   name         = "lab security group"
#   description  = "Security group for allowing all lab space by ip"
  
#   # allow ingress of port 22
#   ingress {
#     cidr_blocks = ["10.255.0.0/16", "10.100.0.0/16"]
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#   } 
# }

resource "aws_security_group" "hypo_vpn_members" {
  vpc_id       = aws_vpc.hypo_vpn_vpc.id
  name         = "VPC members for ${aws_vpc.hypo_vpn_vpc.id}"
  description  = "Security group allowing traffic from ${aws_vpc.hypo_vpn_vpc.id} "

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self=true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = tomap({"Name" = "terraform-hypovpn-${var.name}-sg"}) 
}
