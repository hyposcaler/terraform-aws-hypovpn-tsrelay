output "hypo_vpn_vpc_id" {
  value = aws_vpc.hypo_vpn_vpc.id
}

output "hypo_vpn_subnets" {
  value = aws_subnet.hypo_vpn_subnet.*.id
}

output "hypo_vpn_rtb_main" {
  value = aws_route_table.hypo_vpn_rtb.id
}

output "hypo_vpn_members_sg_id" {
  value = aws_security_group.vpn_members.id
}