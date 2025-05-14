variable "aws_region" {
  default = "eu-west-1"
}

variable "key_name" {
  description = "Nombre de la clave SSH en AWS"
}

variable "pfsense_ami" {
  description = "AMI de pfSense (preparada previamente como imagen personalizada)"
}

variable "victim_ami" {
  description = "AMI base de Ubuntu para la máquina víctima"
}

variable "attacker_ami" {
  description = "AMI base de Ubuntu para el atacante (con Docker)"
}
