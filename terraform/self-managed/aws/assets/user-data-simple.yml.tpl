write_files:
  - path: /root/bootstrap.sh
    permissions: "0700"
    content: |
      #!/bin/bash

      set -ex

      sysctl net.ipv4.ip_forward=1
      sed 's/net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/g' /etc/sysctl.conf > /etc/sysctl.conf

      /etc/eks/bootstrap.sh \
              --apiserver-endpoint "${cluster_endpoint}" \
              --b64-cluster-ca "${certificate_authority}" \
              --kubelet-extra-args "${kubelet_extra_args}" \
              "${cluster_name}"

runcmd:
  - |
    set -x
    (
      while [ ! -f /root/bootstrap.sh ]; do
        sleep 1
      done
      if ! /root/bootstrap.sh; then {
        shutdown now
      }
      fi
    )
