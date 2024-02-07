#######################
## SECURITY GROUP    ##
#######################
#--------
# Locals
#--------

locals {
    ports_tcp	= [22,80,443,3000,8080,9200,5601]
}


#--------------
# Outbound Rule
#--------------
#resource "aws_security_group_rule" "egress" {

#  type        = "egress"
#  from_port   = 0 
#  to_port     = 0
#  protocol    = "-1"  # -1 means all protocols
#  cidr_blocks = ["0.0.0.0/0"]
#  security_group_id = "${aws_security_group.saha_sg.id}"
#}

#------------------------
# Security Group for Saha
#------------------------

resource "aws_security_group" "saha_sg" {
  name        		= "saha-sandbox-sg"
  description 		= "Allow TLS inbound traffic"
  vpc_id      		= "${aws_vpc.saha_vpc.id}"


  dynamic "ingress" {
    for_each		= toset(local.ports_tcp)
    content {
      description      	= "TLS from VPC"
      from_port        	= ingress.value
      to_port          	= ingress.value
      protocol         	= "tcp"
      cidr_blocks      	= ["0.0.0.0/0"]
}
}

tags = {
  "Name"	= "saha-sandbox-sg"
}
}

#------------------->

#------------------------------
# UDP Ingress Rule for Pritunl
#------------------------------
resource "aws_security_group_rule" "udp_ingress" {

  type        = "ingress"
  from_port   = 0 
  to_port     = 65535
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.pritunl_sg.id}"
}


#-------------------------
# Egress Rule for Pritunl
#-------------------------
resource "aws_security_group_rule" "egress" {

  type        = "egress"
  from_port   = 0 
  to_port     = 0
  protocol    = "-1"  # -1 means all protocols
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.pritunl_sg.id}"
}

#----------------------------
# Security Group for Pritunl
#----------------------------

resource "aws_security_group" "pritunl_sg" {
  name        		= "Pritunl_SG"
  description 		= "Allow TLS inbound traffic"
  vpc_id      		= "${aws_vpc.saha_vpc.id}"


  dynamic "ingress" {
    for_each		= toset(local.ports_tcp)
    content {
      description      	= "TLS from VPC"
      from_port        	= ingress.value
      to_port          	= ingress.value
      protocol         	= "tcp"
      cidr_blocks      	= ["0.0.0.0/0"]

}
}


tags = {
  "Name"	= "saha-pritunl-sg"
}
}

#----------------------------------
# Security Group for Elastic Search
#----------------------------------
  
resource "aws_security_group" "saha_elastic" {
  name                  = "saha-sandbox-elastic-sg"
  description           = "Allow TLS inbound traffic"
  vpc_id                = "${aws_vpc.saha_vpc.id}"


  dynamic "ingress" {
    for_each            = toset(local.ports_tcp)
    content {
      description       = "TLS from VPC"
      from_port         = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
}
}

tags = {
  "Name"        = "saha-sandbox-elastic-sg"
}
}

#-------------------------------
# Kubernetes Security Group TCP
#-------------------------------

resource "aws_security_group" "k8s_sg" {
  name        = "saha-sandbox-eks-sg"
  vpc_id      = "${aws_vpc.saha_vpc.id}"

  tags = {
    Name = "saha-sandbox-eks-sg"
  }
}

resource "aws_security_group_rule" "k8s_ingress" {

  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.k8s_sg.id}"
 
}

