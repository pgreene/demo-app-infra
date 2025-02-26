# Repository:demo-app-infra

Backend in AWS for LAMP demo app

## Order of operations
* demo-app-vpc
* alarm-sns-topics for alert notifications
* demo-app-db
* demo-app-ecr for app image
* demo-app-ecs for app cluster

Navigate into each directory and run `terraform init` & `terraform apply`

Currently this only builds in my personal AWS Account and uses terraform cloud for the backend state file. Advantage? An interface / GUI for your infrastructure & it's versioned. 

To run locally, you'll need an API token from terraform cloud.

## Resources

* Database: RDS Aurora Serverless
* Image Repository: ECR
* Frontend: ECS
* EFS mounted to Docker Container in ECS
* VPC (foundation)
* Route53 / DNS
* Certificate Manager for HTTPS