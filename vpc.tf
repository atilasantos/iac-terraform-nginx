resource "aws_security_group" "nginx-security-group" {
    name        = "nginx-security-group"
    description = "Allow inbound ssh and http access"

    ingress {
        description = "HTTP ACCESS"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["${var.subnet_cidr}"]
    }

    ingress {
        description = "SSH ACCESS"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.subnet_cidr}"]
    }
    }

resource "aws_vpc" "nginx-vpc" {
    cidr_block        = "${var.vpc_cidr}"
    instance_tenancy  = "${var.tenancy}"

    tags = {
        Name = "nginx-vpc"
    }
  
}
resource "aws_subnet" "nginx-subnet" {
  vpc_id     = "${aws_vpc.nginx-vpc.id}"
  cidr_block = "${var.subnet_cidr}"
  map_public_ip_on_launch = "true"
}
