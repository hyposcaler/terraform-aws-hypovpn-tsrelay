module "hypo_vpn" {
  aws_region = local.aws_region
  source = "github.com/hyposcaler/terraform-aws-hypovpn-tsrelay"
  externalCIDRs = ["0.0.0.0/0"]
  public_key = "<Replace this with the public SSH key you wish to use>"
  auth_key = "replace this with the tailscale auth key to authenticate with"
}