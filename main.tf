# Replace "vpc-12345678" with the ID of your existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0804cdfc294d203fe"
}

# Replace "sg-12345678" with the ID of your existing security group
data "aws_security_group" "existing_security_group" {
  id = "sg-06552a53c53521df0"
}

# Replace "subnet-group-name" with the name of your existing DB subnet group that includes the chosen subnet(s) for the RDS instance
data "aws_db_subnet_group" "existing_db_subnet_group" {
  name = "my-db-subnet-group"
}

# Create the PostgreSQL RDS instance
resource "aws_db_instance" "postgres" {
  identifier             = "my-postgres-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"  # Change this to your desired instance type
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "postgres"
  password               = "postgres"  # Change this to your desired database password
  parameter_group_name   = "default.postgres15"
  publicly_accessible    = true
  skip_final_snapshot    = true  # Set to false if you want to create a final snapshot on deletion

  # Use the existing VPC, subnet, and subnet group IDs/names
  vpc_security_group_ids = [data.aws_security_group.existing_security_group.id]
  db_subnet_group_name    = data.aws_db_subnet_group.existing_db_subnet_group.name

  # You can set the "availability_zone" attribute if you want to specify a specific AZ for the RDS instance
  # availability_zone = "us-east-1a"
}
