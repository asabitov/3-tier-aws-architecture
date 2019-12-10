resource "aws_security_group" "bastion_sg" {
    name        = "bastion_sg"
    description = "bastion_sg"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks      = [var.admin_ip]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "presentation_alb_sg" {
    name        = "presentation_alb_sg"
    description = "presentation_alb_sg"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "presentation_instance_sg" {
    name        = "presentation_instance_sg"
    description = "presentation_instance_sg"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [join("",[aws_instance.bastion.private_ip,"/32"])]
    }

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.presentation_alb_sg.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "application_alb_sg" {
    name        = "application_alb_sg"
    description = "application_alb_sg"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups  = [aws_security_group.presentation_instance_sg.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "application_instance_sg" {
    name        = "application_instance_sg"
    description = "application_instance_sg"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [join("",[aws_instance.bastion.private_ip,"/32"])]
    }

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.application_alb_sg.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "database_sg" {
    name        = "database_sg"
    description = "database_sg"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.application_instance_sg.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

