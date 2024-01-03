terraform {
  backend "s3" {
    bucket  = "terraform-back-state"
    key     = "website-ecs.tfstate"
    region  = "eu-west-2"
    profile = "luigi"
  }
}