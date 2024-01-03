provider "aws" {
  region  = var.region
  profile = "luigi"
}

#create vpc
module "vpc" {
  source                       = "../../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

#create nat gateway
module "nat_gateway" {
  source                     = "../../modules/nat-gateway"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  internet_gateway           = module.vpc.internet_gateway
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

#security-groups
module "security_groups" {
  source = "../../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

#ecs-iam
module "ecs_tasks_execution_role" {
  source       = "../../modules/ecs-tasks-execution-role"
  project_name = module.vpc.project_name
}

#acm
module "acm" {
  source                        = "../../modules/acm"
  domain_name                   = var.domain_name
  alternative_name              = var.alternative_name
  application_load_balancer_dns = module.application_load_balancer.application_load_balancer_dns
}

#alb
module "application_load_balancer" {
  source                = "../../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_groups.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.acm.certificate_arn
}

#Cluster
module "ecs_cluster" {
  source                       = "../../modules/ecs-reference"
  project_name                 = module.vpc.project_name
  private_app_subnet_az1_id    = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id    = module.vpc.private_app_subnet_az2_id
  ecs_security_group_id        = module.security_groups.ecs_security_group_id
  alb_target_group_arn         = module.application_load_balancer.alb_target_group_arn
  ecs_tasks_execution_role_arn = module.ecs_tasks_execution_role.ecs_tasks_execution_role_arn
  container_image              = var.container_image
  region                       = module.vpc.region
}
