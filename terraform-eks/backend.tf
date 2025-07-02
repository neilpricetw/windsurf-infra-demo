terraform {
  backend "s3" {
    bucket       = "np-tfstate5"
    key          = "terraform/state/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
  }
}
