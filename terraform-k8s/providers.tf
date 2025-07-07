data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "np-tfstate5"
    key    = "terraform/state/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)
  token                  = var.kubernetes_token
}

variable "kubernetes_token" {
  description = "Kubernetes API Bearer token"
  type        = string
  sensitive   = true
}
