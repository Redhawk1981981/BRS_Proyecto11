provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "emulacion-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.2.0/24"]
  enable_nat_gateway = true
}

resource "aws_instance" "pfsense" {
  ami           = var.pfsense_ami
  instance_type = "t3.medium"
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.pfsense.id]
  key_name      = var.key_name
  tags = {
    Name = "pfSense"
  }
}

resource "aws_instance" "victim" {
  ami           = var.victim_ami
  instance_type = "t3.small"
  subnet_id     = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.victim.id]
  key_name      = var.key_name
  tags = {
    Name = "Victim"
  }
}

resource "aws_instance" "attacker" {
  ami           = var.attacker_ami
  instance_type = "t3.small"
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.attacker.id]
  key_name      = var.key_name
  tags = {
    Name = "Attacker"
  }
}

resource "aws_security_group" "pfsense" {
  name_prefix = "pfsense-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "victim" {
  name_prefix = "victim-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.public_subnets[0]]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "attacker" {
  name_prefix = "attacker-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
