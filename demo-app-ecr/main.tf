module "aws-ecr-repository" {
  source  = "app.terraform.io/pgconsulting/ecr/aws"
  version = "1.0.0"
  name = local.name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration = {
    scan_on_push = true
  }
  tags = local.tags
}

module "ecr-repository-policy" {
  source  = "app.terraform.io/pgconsulting/ecr-policy/aws"
  version = "1.0.0"
  ## This substr function assumes the repo url will be 358665735850.dkr.ecr.ca-central-1.amazonaws.com/dev-demo-app-ecr
  repository = substr(module.aws-ecr-repository.repository_url, 48, 16)
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:*"
            ]
        }
    ]
}
EOF
}