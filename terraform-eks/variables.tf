variable "region" {
  description = "AWS region to deploy into"
  type        = string

}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string

}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string

}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)

}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)

}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "kubernetes_host" {
  description = "Kubernetes API server endpoint"
  type        = string
}

variable "kubernetes_ca_certificate" {
  description = "Kubernetes CA certificate (base64 encoded)"
  type        = string
}

variable "kubernetes_token" {
  description = "Kubernetes API Bearer token"
  type        = string
  sensitive   = true
}
