resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_db_instance" "database_instance" {
    name                 = var.database_name
    engine               = "postgres"
    instance_class       = "db.t2.small"
    username             = var.database_user
    password             = var.database_password
    db_subnet_group_name = aws_db_subnet_group.database_subnet_group.id
    allocated_storage    = 20
}

output "database_address" {
    value = aws_db_instance.database_instance.address
}

