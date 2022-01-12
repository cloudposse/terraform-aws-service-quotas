terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}
