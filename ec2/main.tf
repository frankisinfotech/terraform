resource "aws_vpc" "lifebit_vpc" {
  cidr_block 		= 	"172.16.0.0/16"
  enable_dns_hostnames	= 	true
  enable_dns_support	=	true

  tags = {
    Name = "lifebit-vpc"
  }
}


resource "aws_subnet" "lifebit_subnet" {
  vpc_id            	= aws_vpc.lifebit_vpc.id
  cidr_block        	= "${cidrsubnet(aws_vpc.lifebit_vpc.cidr_block, 3, 1)}"
  availability_zone 	= "eu-west-2a"

  tags = {
    Name 		= "lifebit-subnets"
  }
}

locals {
  ports_in		= [22,80,3000]
  ports_out		= [0]
}

resource "aws_security_group" "lifebit_SG" {
  name        		= "lifebit_SG"
  description 		= "Allow TLS inbound traffic"
  vpc_id      		= "${aws_vpc.lifebit_vpc.id}"


  dynamic "ingress" {
    for_each		= toset(local.ports_in)
    content {
      description      	= "TLS from VPC"
      from_port        	= ingress.value
      to_port          	= ingress.value
      protocol         	= "tcp"
      cidr_blocks      	= ["0.0.0.0/0"]
}
}
  dynamic "egress" {
    for_each		= toset(local.ports_out)
    content {
      description      	= "TLS from VPC"
      from_port        	= egress.value
      to_port          	= egress.value
      protocol         	= "-1"
      cidr_blocks      	= ["0.0.0.0/0"]
}
}
#  ingress {
#    description      	= "TLS from VPC"
#    from_port        	= 22
#    to_port          	= 22
#    protocol         	= "tcp"
#    cidr_blocks      	= ["0.0.0.0/0"]
#  }
#  ingress {
#    description      	= "TLS from VPC"
#    from_port        	= 80
#    to_port          	= 80
#    protocol         	= "tcp"
#    cidr_blocks      	= ["0.0.0.0/0"]
#  }

#  egress {
#    from_port        	= 0
#    to_port          	= 0
#    protocol         	= "-1"
#    cidr_blocks      	= ["0.0.0.0/0"]
#  }

  tags = {
    Name 			= "allow_tls"
  }
}


resource "aws_instance" "lifebit" {
  ami           	= "ami-0de842d2477e3b337"
  instance_type 	= "t2.micro"
  key_name 		= aws_key_pair.lifebit.key_name
  security_groups	= ["${aws_security_group.lifebit_SG.id}"]
  
  user_data	= file('install_app.sh') # Where the entire content of the script below is defined in the "install_app.sh" file.
# user_data	= <<EOF

#	#!/bin/bash
	
#	#Installing git and cloning the repository
#	yum install git -y
#	mkdir lifebit_test
#	cd lifebit_test
#	git clone https://github.com/nodejs/examples.git
#	cd examples/servers/express/api-with-express-and-handlebars
#
	#Installing Nodejs
#	yum -y install curl
#	curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
#	yum install -y nodejs
#	npm install
#	npm start &

#EOF

  tags = {
    Name		= "LifeBitVM"
    
}

  subnet_id		= "${aws_subnet.lifebit_subnet.id}"
  }

resource "aws_key_pair" "lifebit" {
  key_name			= "lifebit"
  public_key		= "${file("${path.module}/lifebit.pub")}"
}


resource "aws_eip" "lifebit_eip" {
  instance		= "${aws_instance.lifebit.id}"
  vpc 			= true
}


resource "aws_internet_gateway" "lifebit_gw" {
  vpc_id 		= "${aws_vpc.lifebit_vpc.id}"

  tags = {
    Name 		= "LifeBit_gw"
  }
}

resource "aws_route_table" "lifebit_RTB" {
  vpc_id 		= "${aws_vpc.lifebit_vpc.id}"

  route {
    	cidr_block 	= "0.0.0.0/0"
    	gateway_id 	= "${aws_internet_gateway.lifebit_gw.id}"
  }


  tags = {
    Name = "lifebit_RTB"
  }
}


resource "aws_route_table_association" "lifebit_RTB_AS" {
  subnet_id 		= "${aws_subnet.lifebit_subnet.id}"
  route_table_id	= "${aws_route_table.lifebit_RTB.id}"

   }
