provider "aws" {
    access_key  = var.aws_access_key
    secret_key  = var.aws_secret_key
    region      = var.aws_region
}

data "aws_ami" "centos" {
    owners      = ["679593333241"]
    most_recent = true

    filter {
        name   = "name"
        values = ["CentOS Linux 7 x86_64 HVM EBS *"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
}

resource "aws_instance" "bastion" {
    ami                         = "${data.aws_ami.centos.id}"
    instance_type               = "t2.micro"
    key_name                    =  var.key_name
    subnet_id                   =  aws_subnet.bastion_subnet.id
    vpc_security_group_ids      = [aws_security_group.bastion_sg.id]  
    associate_public_ip_address = true
}

output "bastion_ip_address" {                            
    value = aws_instance.bastion.public_ip          
}                                                     

