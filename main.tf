terraform {
  backend "remote" {
    organization = "vgh"
    workspaces {
      name = "Nyx"
    }
  }
}

locals {
  common_tags = {
    Terraform = "true"
    Group     = "vgh"
    Project   = "prometheus"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

module "notifications" {
  source = "github.com/vghn/terraform-notifications"
  email  = var.email

  common_tags = var.common_tags
}

module "billing" {
  source                  = "github.com/vghn/terraform-billing"
  notifications_topic_arn = module.notifications.topic_arn
  thresholds              = ["1", "2", "3", "4", "5"]
  account                 = "Lyra"

  common_tags = var.common_tags
}

# module "cloudwatch_event_watcher" {
#   source = "github.com/vghn/terraform-cloudwatch_event_watcher"

#   slack_alerts_hook_url = var.slack_alerts_hook_url
#   common_tags           = var.common_tags
# }

# module "cloudtrail" {
#   source = "github.com/vghn/terraform-cloudtrail"

#   common_tags = var.common_tags
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 2.0"

#   name = "VGH"
#   cidr = "10.0.0.0/16"

#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   azs = [
#     "us-east-1a",
#     "us-east-1b",
#     "us-east-1c",
#     "us-east-1d",
#     "us-east-1e",
#     "us-east-1f",
#   ]

#   public_subnets = [
#     "10.0.1.0/24",
#     "10.0.2.0/24",
#     "10.0.3.0/24",
#     "10.0.4.0/24",
#     "10.0.5.0/24",
#     "10.0.6.0/24",
#   ]

#   tags = var.common_tags
# }

# module "prometheus" {
#   source = "github.com/vghn/terraform-prometheus"

#   vpc_id = module.vpc.vpc_id

#   cloudflare_email   = var.cloudflare_email
#   cloudflare_api_key = var.cloudflare_api_key
#   cloudflare_zone_id = var.cloudflare_zone_id

#   common_tags = var.common_tags
# }
