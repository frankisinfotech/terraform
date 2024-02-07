#--------------------
# Printunl VPN Server
#--------------------

resource "aws_instance" "saha_pritunl" {

  ami           	= "ami-0905a3c97561e0b69"
  instance_type 	= "t2.medium"
  key_name 		= aws_key_pair.saha_keypair.key_name
  security_groups	= ["${aws_security_group.saha_sg.id}"]
  subnet_id             = element(aws_subnet.public_subnet.*.id, 0)

#  user_data	        = "${file("install_app.sh")}"

  tags = {
    Name		= "saha-pritunl-vpn"
    
}
}

#------------------------
# EC2 Instances KeyPair
#------------------------


resource "aws_key_pair" "saha_keypair" {
  key_name		= "saha-keypair"
  public_key		= "${file("${path.module}/saha-keypair.pub")}"
}

#------------------------
# EC2 Instances ElasticIP
#------------------------


resource "aws_eip" "saha_eip" {
  instance		= "${aws_instance.saha_pritunl.id}"
  domain                = "vpc"

  tags = {
    Name                = "saha-eip"
}
}

#------------------------
# Multiple EC2 Instances
#------------------------

#resource "aws_instance" "saha_random_ec2" {
#  count                 = 3
#  ami                   = "ami-0905a3c97561e0b69"
#  instance_type         = "t2.medium"
#  key_name              = aws_key_pair.saha_keypair.key_name
#  security_groups       = ["${aws_security_group.saha_sg.id}"]
#  subnet_id             = element(aws_subnet.public_subnet.*.id, 0)


#  tags = {
#    Name                = "saha-multiple-${count.index + 1}"

#}
#}

#----------------
# Jenkins Server
#----------------

resource "aws_instance" "saha_jenkins" {

  ami                   = "ami-0905a3c97561e0b69"
  instance_type         = "t2.medium"
  key_name              = aws_key_pair.saha_keypair.key_name
  security_groups       = ["${aws_security_group.saha_sg.id}"]
  subnet_id             = element(aws_subnet.public_subnet.*.id, 0)


  tags = {
    Name                = "saha-jenkins-server"

}
}

#----------------------
# Elastic Search Server
#----------------------

resource "aws_instance" "saha_elastic" {

  ami                   = "ami-0905a3c97561e0b69"
  instance_type         = "t2.medium"
  key_name              = aws_key_pair.saha_keypair.key_name
  security_groups       = ["${aws_security_group.saha_sg.id}"]
  subnet_id             = element(aws_subnet.public_subnet.*.id, 0)


  tags = {
    Name                = "saha-elastic-server"

}
}
