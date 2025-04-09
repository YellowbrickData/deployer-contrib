data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

variable "ami_id" {
  description = "The AMI ID to use for the operator node group."
  type        = string
}

variable "cert_manager_version" {
  description = "The version of the cert-manager addon to install."
  type        = string
  default     = "v1.17.1-eksbuild.2"
}

variable "cluster_autoscaler_namespace" {
  description = "The namespace for the cluster autoscaler."
  type        = string
  default     = "kube-system"
}

variable "cluster_name" {
  description = "The EKS cluster name."
  type        = string
}

variable "node_group_subnet_id" {
  description = "The subnet ID for the operator nodegroup. This subnet AZ will also be considered the primary AZ."
  type        = string
}

variable "node_key_name" {
  description = "The key name to use for the operator nodegroup."
  type        = string
  default     = ""
}

variable "node_role_arn" {
  description = "The ARN of the IAM role to use for the node group."
  type        = string
}

variable "oidc_provider" {
  description = "The OIDC provider name. This should be without https://"
  type        = string
}

variable "placement_group_name" {
  description = "The placement group name."
  type        = string
  default     = null
}

variable "region" {
  type = string
}

variable "registry" {
  type = string
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "yb_operator_instance_type" {
  type    = string
  default = "t3.large"
}

variable "yb_operator_labels" {
  type = map(string)
  default = {
    "cluster.yellowbrick.io/hardware_type" = "t3.large",
    "cluster.yellowbrick.io/node_type"     = "yb-op-standard"
  }
}

variable "yb_operator_namespace" {
  type = string
}

variable "yb_operator_nodegroup_taints" {
  description = "The taints to apply to the operator nodegroup."
  type = list(object({
    effect = string
    key    = string
    value  = string
  }))
  default = [
    {
      effect = "NO_SCHEDULE"
      key    = "cluster.yellowbrick.io/owned"
      value  = "true"
    }
  ]
}
