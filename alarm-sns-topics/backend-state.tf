# https://www.terraform.io/docs/backends/types/remote.html#basic-configuration
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "pgconsulting"

    workspaces {
      name = "demo-app-infra-ops-alarm-sns-topics"
    }
  }
}
