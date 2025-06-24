resource "aws_vpc" "multi-cloud-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "multi-cloud-vpc"
    }
}

resource "aws_internet_gateway" "multi-cloud-igw" {
    vpc_id = aws_vpc.multi-cloud-vpc.id

    tags = {
        Name = "multi-cloud-igw"
    }
}

resource "aws_subnet" "multi-cloud-subnet" {
    vpc_id = aws_vpc.multi-cloud-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true

    tags ={
        Name = "multi-cloud-subnet"
    }    
}

resource "aws_security_group" "multi-cloud-sg" {
  name = "multi-cloud-sg"
  description = "Secirity group for multi cloud project"
  vpc_id = aws_vpc.multi-cloud-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "multi-cloud-key" {
    key_name = "multi-cloud-key"
    public_key = file("C:/Users/019105/.ssh/id_rsa.pub")
}

resource "aws_instance" "multi-cloud-instance" {
    ami = "ami-0d1b5a8c13042c939"
    instance_type = "t2.micro"

    subnet_id = aws_subnet.multi-cloud-subnet.id
    vpc_security_group_ids = [aws_security_group.multi-cloud-sg.id]
    key_name = aws_key_pair.multi-cloud-key.key_name

    tags ={
        Name = "multi-cloud-instance"
    }
}