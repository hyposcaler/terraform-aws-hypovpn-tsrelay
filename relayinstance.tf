resource "aws_key_pair" "tailscale_relay_key" {
  key_name   = "tailscale_relay_key"
  public_key = var.public_key
}

data "template_file" "user_data" {
  template = file("${path.module}/relay-cloudinit.yml")
  vars = {
    auth_key           = var.auth_key
    vpn_routes         = var.vpn_routes
  }
}

resource "aws_instance" "tailscale_relay_instance" {
  ami           = "ami-0be2609ba883822ec"
  instance_type = "t3.small"
  subnet_id = aws_subnet.hypo_vpn_subnet[0].id
  vpc_security_group_ids = [
        aws_security_group.hypo_vpn_ssh_sg.id,
        aws_security_group.hypo_vpn_members.id
    ]
#   iam_instance_profile = aws_iam_instance_profile.kop_instance_profile.id
  associate_public_ip_address = true
  key_name = "tailscale_relay_key"
  user_data = data.template_file.user_data.rendered

   tags = map(
    "Name", "terraform-hypovpn-${var.name}-tailscale_relay",
  ) 
}


