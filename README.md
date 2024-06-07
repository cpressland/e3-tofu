# e3-tf

An OpenTofu Project for the Element3 Team to evaluate my skillset as a DevOps Engineer.

## Repo Structure

```
├── README.md                  # This file
├── main.tf                    # Where modules are instantiated from
├── providers.tf               # Where Azure Subscriptions are configured
└── modules
    └── cluster
        ├── main.tf            # Root of the 'cluster' Module
        ├── vars.tf            # Variable definitions for 'cluster' Module
        ├── network.tf         # Provisions Network Essentials, VNet, Subnets etc.
        └── kube.tf            # Provisions a Kubernetes Cluster
```

## Why OpenTofu instead of Terraform?

Hashicorp has been aquired by IBM several months after changing the Terraform Source Code license from MPL to BSL. It is likely that the FOSS versions of Terraform will be discontinued and turned into a pay-for service via Terraform Cloud. [OpenTofu](https://opentofu.org/) is a fork of Terraform that aims to fix this misdirection.
