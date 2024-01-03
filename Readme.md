# Iac for Terraform (aws)

### Repository to create an ECS with ALB

## What is Terraform?
### Terraform is an Infrastructure as Code (IaC) tool that enables the automatic creation, modification, and deletion of infrastructure.
### Terraform can manage resources from various cloud service providers such as AWS, Google Cloud, Azure, etc.
## Installation of the Terraform plugin for Visual Studio Code.

- It is recommended to install the Terraform plugin for Visual Studio Code.

- The plugin is called HashiCorp Terraform and has been developed by the company HashiCorp.

## Diagrama

![Descripción de la imagen](/Diagram/cluster_web_service.png)

```Bash
python3 index.py
```

### Initialize the working directory.
#### First, you need to download the necessary plugins for the provider and the module specified in the configuration file.

```Bash
cd modules/Colmena-website-ecs
terrafrom init
```

### Format and validate the configuration file.
#### Terraform provides a command to format the configuration file, making it more readable. Some of the tasks performed by this command include adjusting indentation, sorting arguments within configuration blocks, and more.


```Bash
terraform fmt
```

#### To validate the syntax of the configuration file.

```Bash
terraform validate
```

### Display the changes that will be made.
#### Allow the user to review the changes before applying them to the provider.

```Bash
terraform plan
```

### Apply the changes.
#### Create the resources from the configuration file in your AWS account.

```Bash
terraform apply
```

### Delete resources
#### Delete the resources indicated in the provider

```Bash
terraform destroy
```

## Referencias
<li><a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code"r1="nofollow">✔️ What is Infrastructure as Code with Terraform?</a></li>
<li><a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli"r1="nofollow">✔️ Install Terraform</a></li>
<li><a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build"r1="nofollow">✔️ Build Infrastructure</a></li>
<li><a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-change"r1="nofollow">✔️ Change Infrastructure</a></li>
<li><a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-destroy"r1="nofollow">✔️ Destroy Infrastructure</a></li>
<li><a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-variables"r1="nofollow">✔️ Define Input Variables</a></li>





