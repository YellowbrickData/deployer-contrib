variable "ami_id" {
  type        = string
  description = "AMI ID used for the node group."
}

variable "capacity_type" {
  type        = string
  description = "The capacity type of the node group. Can be either ON_DEMAND or SPOT."
  default     = "ON_DEMAND"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "desired_size" {
  type        = number
  description = "The desired number of instances in the node group."
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the worker nodes."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the node group."
  default     = {}
}

variable "max_size" {
  type        = number
  description = "The maximum number of instances in the node group."
  default     = 10
}

variable "min_size" {
  type        = number
  description = "The minimum number of instances in the node group."
  default     = 0
}

variable "node_group_name" {
  type = string
}

variable "node_key_name" {
  type        = string
  description = "Key name for the worker node EC2 instances (optional)."
  default     = ""
}

variable "node_role_arn" {
  type        = string
  description = "ARN of the IAM Role to attach to the worker nodes in this node group."
}

variable "placement_group_name" {
  type        = string
  description = "Name of the placement group to use for the node group."
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the node group."
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID into which the node group will launch instances."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources."
  default     = {}
}

variable "taints" {
  type = list(object({
    effect   = string
    key      = string
    value    = string
    operator = string
  }))
  description = "List of taints to apply to the node group."
  default     = []
}

variable "user_data" {
  type        = string
  description = "User data script to run on the worker nodes. It is expected to be base64-encoded."
  default     = ""
}
