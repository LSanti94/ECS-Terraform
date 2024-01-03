from diagrams import Cluster, Diagram, custom
from diagrams.aws.compute import ElasticContainerService, EC2ContainerRegistry, Fargate, EC2ContainerRegistryImage
from diagrams.aws.network import Route53, ALB, PublicSubnet, PrivateSubnet, RouteTable, InternetGateway, VPC, NATGateway
from diagrams.aws.security import ACM, IdentityAndAccessManagementIamRole
from diagrams.aws.general  import Users
from diagrams.aws.storage import S3

# Add class for Terraform
class TerraformIcon(custom.Custom):
    def __init__(self, label, icon_path, **kwargs):
        super().__init__(label, icon_path, **kwargs)

with Diagram("Cluster Web Service", show=True):
    vpc = VPC("VPC")
    terraform_icon = TerraformIcon("Terraform", "./terraform.png")
    with Cluster("Region London(eu-west-2)"):
        ig = InternetGateway("Internet Gateway")
        app1 = Users("https://www.colmena.click")
        app2 = Users("https://www.colmena.click")
        iam = IdentityAndAccessManagementIamRole("Iam-Role")
        dns = Route53("dns")
        acm = ACM("ACM")
        s3 = S3("bucket S3")

        with Cluster("Public Subnet AZ1 - 10.0.0.0/24"):
            sp = PublicSubnet("PublicSubnet")
            rt_public = RouteTable("PublicRouteTable")
            ng = NATGateway("Nat Gateway")
            sp - rt_public

        with Cluster("Public Subnet AZ2 - 10.0.1.0/24"):
            sp2 = PublicSubnet("PublicSubnet")
            rt_public2 = RouteTable("PublicRouteTable")
            ng2 = NATGateway("Nat Gateway")
            sp2 - rt_public2

        with Cluster("Aplication Load Balancer"):
            spalb = PublicSubnet("PublicSubnet")
            alb = ALB("ALB")
            security = VPC("Security Groups")
            alb - spalb

        with Cluster ("Private App Subnet AZ1 - 10.0.2.0/24"):
            ecs = ElasticContainerService("App1")
            spriv = PrivateSubnet("Subnet private")
            rt_private_app1 = RouteTable("PrivateRouteTable")
            fgt = Fargate("AWS Fargate")
            container = EC2ContainerRegistryImage("Image")
            spriv - rt_private_app1
            ecs - container


        with Cluster ("Private App Subnet AZ2 - 10.0.3.0/24"):
            ecs2 = ElasticContainerService("App2")
            spriv2 = PrivateSubnet("Subnet private")
            rt_private_app2 = RouteTable("PrivateRouteTable")
            fgt2 = Fargate("AWS Fargate")
            container2 = EC2ContainerRegistryImage("Image")
            spriv2 - rt_private_app2
            ecs2 - container2

        terraform_icon >> vpc
        terraform_icon - s3
        vpc >> ig >> ng >> alb
        ig >> ng2 >> alb >> dns
        alb - acm
        alb - ecs
        alb - ecs2
        alb - security
        ecs2 - app2
        ecs - app1
        iam - container
        iam - container2
        