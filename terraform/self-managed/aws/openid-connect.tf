locals {

  # The Root CA Thumbprint for an OpenID Connect Identity Provider is currently
  # Being passed as a default value which is the same for all regions and is
  # valid until (Jun 28 17:39:16 2034 GMT).
  # https://crt.sh/?q=9E99A48A9960B14926BB7F3B02E22DA2B0AB7280
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  # https://github.com/terraform-providers/terraform-provider-aws/issues/10104

  aws_eks_ca_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.oidc_provider_url == "" ? 1 : 0

  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.aws_eks_ca_thumbprint]

  tags = var.tags
}
