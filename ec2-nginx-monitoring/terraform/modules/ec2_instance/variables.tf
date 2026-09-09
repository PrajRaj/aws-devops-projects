variable "ami_value" {
  description = "The value of the AMI ID to use for the instance"
}

variable "instance_type_value" {
  description = "The instance type to use for the instance"
}

variable "subnet_id_value" {
  description = "The ID of the subnet to launch the instance in"
}

variable user_data {
  description = "The user data to provide when launching the instance"
  default     = "null"
  type        = string
}

/* Commenting this block out because we are using an existing key pair instead of creating a new one. If you want to create a new key pair, uncomment this block and provide the public key in the variable `public_key`.
variable public_key {
  description = "The public key to use for the key pair"
  type        = string
}*/