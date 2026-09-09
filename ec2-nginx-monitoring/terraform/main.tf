provider "aws" {
    region = "us-east-1"
}
#Calls the ec2_instance module and passes the required variables
module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_value= "ami-0b6d9d3d33ba97d99"
    instance_type_value = "t3.micro"
    subnet_id_value = "subnet-0854648e8da93c917"
    user_data = templatefile("user_data.sh", {
  monitor_content = file("${path.root}/../monitor.sh")
})
    #public_key = file("~/.ssh/id_rsa.pub")#Using existing key pair instead of creating a new one. If you want to create a new key pair, uncomment this line and provide the public key.
}
output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "instance_id" {
    value = module.ec2_instance.instance_id
    }

   