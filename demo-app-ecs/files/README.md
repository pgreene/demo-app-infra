Read this article in it's entirety to understand how to access jenkins shell 

https://aws.amazon.com/blogs/containers/new-using-amazon-ecs-exec-access-your-containers-fargate-ec2/

If you are not familiar with Docker, please install it locally & learn how to gain shell access to your Docker container locally.

https://docs.docker.com/engine/reference/commandline/exec/

https://stackoverflow.com/questions/30172605/how-do-i-get-into-a-docker-containers-shell

Trying to access Docker Shell in AWS ECS using Fargate was unsuccessful, instead mounting the EFS Network Drive on the bastion host to gain jenkins shell access worked. 
