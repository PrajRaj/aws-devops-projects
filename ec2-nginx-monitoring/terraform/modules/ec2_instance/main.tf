
resource "aws_instance" "my_instance" {
  ami                     = var.ami_value
  instance_type           = var.instance_type_value
  subnet_id               = var.subnet_id_value
  user_data               = var.user_data
  key_name                = "aws_login"
}

/* Commenting this block out because we are using an existing key pair instead of creating a new one. If you want to create a new key pair, uncomment this block and provide the public key in the variable `public_key`.
resource "aws_key_pair" "my_key_pair" {
  key_name   = "nginx-key-pair"
  public_key = var.public_key
} */