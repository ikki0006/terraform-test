provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      "Environment" = var.env
      "CreateBy"    = "terraform"
    }
  }
}
