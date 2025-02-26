# Repository:demo-app-infra

Backend in AWS for LAMP demo app

## Order of operations
* demo-app-vpc
* alarm-sns-topics for alert notifications
* demo-app-db
* demo-app-ecr for app image
* demo-app-ecs for app cluster

Navigate into each directory and run `terraform init` & `terraform apply`

## Resources

* Database: RDS Aurora Serverless
* Image Repository: ECR
* Frontend: ECS
* EFS mounted to Docker Container in ECS
* VPC (foundation)
* Route53 / DNS
* Certificate Manager for HTTPS