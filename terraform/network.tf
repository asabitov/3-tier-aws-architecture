resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "bastion_subnet" {        
    vpc_id            = "${aws_vpc.vpc.id}"      
    cidr_block        = "10.0.254.0/24"            
    availability_zone = var.availability_zone_a  
}                                                

resource "aws_subnet" "public_subnet_1" {
    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "10.0.1.0/24"
    availability_zone = var.availability_zone_a
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "10.0.2.0/24"
    availability_zone = var.availability_zone_b
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "10.0.3.0/24"
    availability_zone = var.availability_zone_a
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "10.0.4.0/24"
    availability_zone = var.availability_zone_b
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_eip" "eip_1" {
}

resource "aws_eip" "eip_2" {
}

resource "aws_nat_gateway" "nat_gw_1" {
    allocation_id = "${aws_eip.eip_1.id}"
    subnet_id     = "${aws_subnet.public_subnet_1.id}"
}

resource "aws_nat_gateway" "nat_gw_2" {
    allocation_id = "${aws_eip.eip_2.id}"
    subnet_id     = "${aws_subnet.public_subnet_2.id}"
}

resource "aws_route_table" "bastion_subnet_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table_association" "bastion_route_table_association" {
  subnet_id      = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.bastion_subnet_route_table.id
}

resource "aws_route_table" "public_subnet_1_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table_association" "public_subnet_1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_1_route_table.id
}

resource "aws_route_table" "public_subnet_2_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table_association" "public_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_2_route_table.id
}

resource "aws_route_table" "private_subnet_1_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw_1.id}"
    }
}

resource "aws_route_table_association" "private_subnet_1_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet_1_route_table.id
}

resource "aws_route_table" "private_subnet_2_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw_2.id}"
    }
}

resource "aws_route_table_association" "private_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet_2_route_table.id
}

