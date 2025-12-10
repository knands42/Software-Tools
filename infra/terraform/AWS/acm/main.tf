resource "aws_acm_certificate" "vpn_server" {
  private_key       = file("${var.vpn_certs_path}/server.key")
  certificate_body  = file("${var.vpn_certs_path}/server.crt")
  certificate_chain = file("${var.vpn_certs_path}/ca.crt")
}

resource "aws_acm_certificate" "vpn_client" {
  certificate_body  = file("${var.vpn_certs_path}/client.crt")
  private_key       = file("${var.vpn_certs_path}/client.key")
  certificate_chain = "" # No chain for a self-signed cert
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description = "VPN access to private subnets"

  # server certificate stored in ACM
  server_certificate_arn = aws_acm_certificate.vpn_server.arn

  authentication_options {
    type = "certificate-authentication"
    # ca certificate stored in ACM
    root_certificate_chain_arn = aws_acm_certificate.vpn_client.arn
  }

  client_cidr_block  = "172.20.0.0/16"
  split_tunnel       = true
  transport_protocol = "udp"
  vpn_port           = 443

  connection_log_options {
    enabled = false # TODO: enable logs on cloudwatch
  }

  dns_servers = ["8.8.8.8"]
}

resource "aws_ec2_client_vpn_network_association" "private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.private_subnets[0]
}

resource "aws_ec2_client_vpn_authorization_rule" "allow_vpc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = var.vpc_cidr_block
  authorize_all_groups   = true
}
