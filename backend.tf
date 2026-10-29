```hcl
terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "depi-team-s55-tfstate-xyz"
    key          = "project/terraform.tfstate"
    region       = "us-east-1"
    profile      = "depi-project"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "depi-project"

  default_tags {
    tags = {
      Project   = "secure-aws-network-hybrid-connectivity"
      ManagedBy = "terraform"
    }
  }
}
```
