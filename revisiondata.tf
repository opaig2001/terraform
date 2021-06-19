
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "myvpc"
}
}

resource "aws_subnet" "myvpc_public_subnet" {
    vpc_id = "${aws_vpc.myvpc.id}"
    cidr_block = "${var.subnet_one_cidr[1]}"
    availability_zone = "us-west-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "vmyvpc_public_subnet"
    }
}

resource "aws_subnet" "myvpc_private_subnet_one" {
    vpc_id = "${aws_vpc.myvpc.id}"
    cidr_block = "${var.subnet_one_cidr[0]}"
    availability_zone = "us-west-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "vmyvpc_public_subnet"
    }
}
resource "aws_subnet" "myvpc_private_subnet_two" {
    vpc_id = "${aws_vpc.myvpc.id}"
    cidr_block = "${var.subnet_two_cidr[0]}"
    availability_zone = "us-west-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "vmyvpc_public_subnet"
    }
}
resource "aws_subnet" "myvpc_private_subnet_twob" {
    vpc_id = "${aws_vpc.myvpc.id}"
    cidr_block = "${var.subnet_two_cidr[1]}"
    availability_zone = "us-west-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "vmyvpc_public_subnet"
    }
}
resource "aws_internet_gateway" "myvpc_internet_gateway" {
    vpc_id = "${aws_vpc.myvpc.id}"
    tags= {
        Name = "myvpc_internet_gateway"
}
}
# create public route table (assosiated with internet gateway)
resource "aws_route_table" "myvpc_public_subnet_route_table" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
    cidr_block = "${var.route_table_cidr}"
    gateway_id = "${aws_internet_gateway.myvpc_internet_gateway.id}"
    }

    tags = {
                Name = "myvpc_public_subnet_route_table"
    }
}
# create private subnet route table
resource "aws_route_table" "myvpc_private_subnet_route_table" {
    vpc_id = "${aws_vpc.myvpc.id}"
    tags = {
            Name = "myvpc_private_subnet_route_table"
    }
}
## create default route table
resource "aws_default_route_table" "myvpc_main_route_table" {
    default_route_table_id = "${aws_vpc.myvpc.default_route_table_id}"
    tags = {
        Name = "myvpc_main_route_table"
}

}
## associate public subnet with public route table
resource "aws_route_table_association" "myvpc_public_subnet_route_table" {
    subnet_id = "${aws_subnet.myvpc_public_subnet.id}"
    route_table_id = "${aws_route_table.myvpc_public_subnet_route_table.id}"
}
## associate private subnets with private route table
resource "aws_route_table_association" "myvpc_private_subnet_one_route_table_assosiation" {
    subnet_id = "${aws_subnet.myvpc_private_subnet_one.id}"
    route_table_id = "${aws_route_table.myvpc_private_subnet_route_table.id}"
}
resource "aws_route_table_association" "myvpc_private_subnet_two_route_table_assosiation" {
    subnet_id = "${aws_subnet.myvpc_private_subnet_two.id}"
    route_table_id = "${aws_route_table.myvpc_private_subnet_route_table.id}"
}
   # create security group for web
resource "aws_security_group" "web_security_group" {
    name = "web_security_group"
    description = "Allow all inbound traffic"
    vpc_id = "${aws_vpc.myvpc.id}"
    tags = {
        Name = "myvpc_web_security_group"
}
}


## create security group ingress rule for web
resource "aws_security_group_rule" "web_ingress" {
    count = "${length(var.web_ports)}"
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "${element(var.web_ports, count.index)}"
    to_port = "${element(var.web_ports, count.index)}"
    security_group_id = "${aws_security_group.web_security_group.id}"
}
## create security group egress rule for web
resource "aws_security_group_rule" "web_egress" {
    count = "${length(var.web_ports)}"
    type = "egress"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "${element(var.web_ports, count.index)}"
    to_port = "${element(var.web_ports, count.index)}"
    security_group_id = "${aws_security_group.web_security_group.id}"
}


resource "aws_instance" "my_web_instance" {
  ami                    = "${lookup(var.images, var.region)}"
  instance_type          = "t2.micro"
  key_name               = "terra"
  vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]
  subnet_id              = "${aws_subnet.myvpc_public_subnet.id}"
  tags = {
    Name = "my_web_instance"
  }
  volume_tags = {
    Name = "my_web_instance_volume"
  }
provisioner "remote-exec" {
  connection   {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    host        = self.public_ip
    private_key = " ${var.public_key_pair }"
    
  }
  
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo cd /var/www/html",
      "sudo touch index.html",
      "sudo chown -R ec2-user:index.html",
      "sudo echo 'WELCOME TO GEMEAUXWORLD.COM' >index.html",
      "sudo yum install -y mysql php php-mysql",
      "sudo chmod 600 .ssh/terra.rsa"
      ]
  }

provisioner "file" { #copy the index file from local to remote
   source      = "d:\\terraform\\index.php"
   destination = "/tmp/index.php"
  }
provisioner "remote-exec" {
   inline = [
    "sudo mv /tmp/index.php /var/www/html/index.php"
   ]
}

# resource "aws_key_pair" "terra_key" {
#     key_name    = "terra"
#     public_key_pair = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2llOuNWOEKjgaNX84ygpeIL5mGqgq0myvFZrSKgjJBfNOt0yFTIgJQtJokmQPav4e1l3oyuO51skldXYJTEgO8lSKaI95vbiIxre0VST1/0BC5XpZKeTexDEtVWvAhrOE2r70BA0PzBrkcCVF4Q+vIsq40Qu1v1KQytEmwuZnG/jrvz5Xw3IFiuUJCDdR66z/D2OrWDhygweXB4pMUIGRVJmvY0l/wg5IN667P0okXoM9VY1NmfTqApHri1Bzf7wkZOT+HZiD7tbd59jUAqzNZJMSW7Fp1prAFAKuiVoOI+PJgvVAB6peY5HIL1jc+X7WsaRRKszG9z3BbqNAV5op ec2-user"
# }
# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
# }


# resource "aws_db_instance" "my_database_instance" {
#         allocated_storage = "20"
#         storage_type = "gp2"
#         engine = "mysql"
#         engine_version = "5.7"
#         instance_class = "db.t2.micro"
#         port = 3306
#         vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]
#         db_subnet_group_name = "${aws_subnet.myvpc_private_subnet_one.id}"
#         name = "mydb"
#         identifier = "mysqldb"
#         username = "myuser"
#         password = "mypassword"
#         parameter_group_name = "default.mysql5.7"
#         skip_final_snapshot = true
#         tags = {
#             Name = "my_database_instance"
#     }

# }
}
#     output "name" {
#         value = "public_ip"
#     }
# }
  
#   resource "<provider>_<resource_type""name{
#     config options ....
#     key = "value"
#     key2 = "another value"