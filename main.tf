/*
 The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision infrastructure.
 Terraform installs providers from the Terraform Registry by default.
 In this example configuration, the aws provider's source is defined as hashicorp/aws,
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.0.0"
}

/*
 The provider block configures the specified provider, in this case aws.
 You can use multiple provider blocks in your Terraform configuration to manage resources from different providers.
*/
provider "aws" {
  region = "eu-west-1"
}


/*
 Use resource blocks to define components of your infrastructure.
 A resource might be a physical or virtual component such as an EC2 instance.
 A resource block declares a resource of a given type ("aws_instance") with a given local name ("app_server").
 The name is used to refer to this resource from elsewhere in the same Terraform module, but has no significance outside that module's scope.
 The resource type and name together serve as an identifier for a given resource and so must be unique within a module.

 For full description of this resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
*/

#resource "aws_key_pair" "demo_key_pair" {
#  key_name   = "bibi_key_pair"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2nQhQBYiDvGQpMYuFT3RwOZ0DFV/mPHI7fzIb5RoIIZOkgr48hAW5swaGgCJcYUv8ABOGVsHjYdax7kNq9pCZocsbfQ/lI1F48BhWPgIilCvAFkppjBbflP0ADlXp4v50fbR/TStK8VMWCbjKMHxmGs14BVNe9Db6kWjNFlACh6gbJmpC5tF2wM5MTs2qrHRw701Q8OJftVLkQB9gOu8KCFgfoocMijr5E3MsPrdwouBgQ3pm1tPkAdLAJvAgQOGj6Pd6PEDlj2Kqh8mzZYGaOk/yinu0eNJ0T7yABhixXyKIuUB0t56NqqqDYjMFwYd5KK81e++CnzS9egufgI93"
#}


resource "aws_instance" "app_server" {
  ami                    = "ami-01dd271720c1ba44f"
  instance_type          = "t2.micro"
  key_name = "bibi_key_pair"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8089 &
              EOF

  user_data_replace_on_change = true



  tags = {
    Name = "bibi-instance1"
    tf   = "true"
  }
}
