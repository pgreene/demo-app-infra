terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "pgconsulting"
    workspaces {
      name = "pgc-dev-demo-app-ecs"
    }
  }
}