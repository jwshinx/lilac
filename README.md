# Lilac

Terraform exercise for simple api on AWS. Postgres RDS, EC2, ECS, ECR

1. Bastion EC2 instance
2. After ssh-ing into bastion server, psql into Postgres RDS
3. ECS Fargate pulls colleges-api Go api image from ECR. Deploys task definitions and services
4. Exposes two endpoints "/students" and "/colleges"
5. Includes networking infrastructure
