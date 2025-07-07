# Terraform Kubernetes Layer

This directory is for Terraform code that manages Kubernetes resources on top of the EKS cluster.

- Uses the Kubernetes provider
- Reads EKS cluster connection info from terraform-eks remote state
- Example resources: aws-auth configmap, namespaces, deployments, etc.

See providers.tf for provider setup using remote state.
