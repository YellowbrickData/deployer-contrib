# AWS NLB Static IP Configuration Terraform Module

This Terraform module allows you to recreate an existing Kubernetes Service Network Load Balancer (NLB) with static IP addresses in AWS. It assumes a working knowledge of Kubernetes services, AWS load balancers, listeners, and target groups.

## Usage Instructions

### 1. Retrieve Existing Parameters

First, identify your existing Kubernetes services related to your Yellowbrick installation:

```sh
kubectl get services --all-namespaces
```

Locate the services named `yb-manager-service` and `ybinst-<instanceName>`, both within your installation's namespace.

When you've identified these services, note the `EXTERNAL-IP` addresses. You'll use these to locate the corresponding AWS Network Load Balancers (NLBs). For each NLB, you must record:

- Load Balancer Name
- VPC ID
- Subnet IDs
- Listener port numbers and their associated target group names

### 2. Terraform Module Configuration

Below is an example of configuring the module. Note that existing target groups from your current installation are referenced directly—this module does not create new target groups:

```terraform
module "yb_manager_nlb" {
  source = "./modules/aws-nlb-static-ip"

  load_balancer_name = "a6995ba2ae90c4cbeb142e97f24e7c35"
  vpc_id             = "vpc-02cf9fa5499083092"

  subnet_mappings = [
    {
      subnet_id            = "subnet-0faea141bffe261ed"
      private_ipv4_address = "10.200.0.10"
    },
    {
      subnet_id            = "subnet-041d05e3173157659"
      private_ipv4_address = "10.200.4.10"
    }
  ]

  target_groups = [
    {
      listener_port     = 80
      listener_protocol = "TCP"
      target_group_name = "k8s-ybdemo-ybmanage-5b39522cb5"
    },
    {
      listener_port     = 443
      listener_protocol = "TCP"
      target_group_name = "k8s-ybdemo-ybmanage-4659cebd70"
    }
  ]

  tags = {
    "cluster_yellowbrick_io_creator" = "yb-install"
    "cluster_yellowbrick_io_name"    = "demo"
    "cluster_yellowbrick_io_owner"   = "yb-install"
    "kubernetes.io/cluster/demo"     = "owned"
    "kubernetes.io/service-name"     = "yb-demo/yb-manager-service"
  }
}
```

This should be done for each service load balancer. In this example, the static private IP4 addresses used are 10.200.0.10 and 10.200.4.10.

### 3. Import Existing Load Balancers

Next, import each existing load balancer into the Terraform state:

```sh
terraform import module.yb_manager_nlb.aws_lb.this <nlb-arn>
terraform import module.ybd_nlb.aws_lb.this <nlb-arn>
```

### 4. Taint and Recreate Load Balancers

Mark imported resources for recreation by tainting them. Terraform will destroy and recreate each NLB during the next apply:

```sh
terraform taint module.yb_manager_nlb.aws_lb.this
terraform taint module.ybd_nlb.aws_lb.this
```

### 5. Apply Changes

Review and apply the Terraform changes:

```sh
terraform plan
terraform apply
```

After completion, the NLBs will be configured with the specified static private IP addresses.

### 6. Update Kubernetes Service

To trigger Kubernetes to reconcile and update the `EXTERNAL-IP` for each service, add an arbitrary annotation:

```sh
kubectl annotate service -n <namespace> yb-manager-service overrideStatic=true --overwrite
kubectl annotate service -n <namespace> ybinst-<instanceName> overrideStatic=true --overwrite
```

The annotation's value does not matter—it is only necessary to trigger a reconcile and can be removed afterward.

---

This approach ensures minimal downtime and a clean transition to using static private IP addresses with your existing AWS NLBs.
