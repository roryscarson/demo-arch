//Security group - A
resource "aws_security_group" "internet_to_alb" {
  name        = "internet_to_alb"
  description = "Expose ALB to the internet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "internet_to_alb"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_alb" {
  security_group_id = aws_security_group.internet_to_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_egress_rule" "allow_tls_alb" {
  security_group_id = aws_security_group.internet_to_alb.id
  cidr_ipv4         = "10.0.0.0/24" //public subnet all AZs
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

//Security group - B
resource "aws_security_group" "internet_to_k8s" {
  name        = "internet_to_k8s"
  description = "Expose K8s to the internet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "internet_to_k8s"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_k8s" {
  security_group_id = aws_security_group.internet_to_k8s.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_egress_rule" "allow_tls_k8s" {
  security_group_id = aws_security_group.internet_to_k8s.id
  cidr_ipv4         = "10.0.0.0/24" //public subnet all AZs"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_k8s" {
  security_group_id = aws_security_group.internet_to_k8s.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_http_k8s" {
  security_group_id = aws_security_group.internet_to_k8s.id
  cidr_ipv4         = "10.0.0.0/24" //public subnet all AZs"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

//Security group - C
resource "aws_security_group" "public_to_private" {
  name        = "public_to_private"
  description = "Allow access to private subnet from public ones"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "public_to_private"
  }
}

resource "aws_db_subnet_group" "rds_subnet_groups" {
  name       = "rds_subnets"
  subnet_ids = [
    aws_subnet.private1-euw1a.id
    ]
  tags = {
    Name = "rds_subnets"
  }
}
resource "aws_vpc_security_group_ingress_rule" "private_rds" {
  security_group_id = aws_security_group.public_to_private.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}
resource "aws_vpc_security_group_egress_rule" "private_rds" {
  security_group_id = aws_security_group.public_to_private.id
  cidr_ipv4         = aws_subnet.private1-euw1a.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}
resource "aws_vpc_security_group_ingress_rule" "private_http" {
  security_group_id = aws_security_group.public_to_private.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "private_http" {
  security_group_id = aws_security_group.public_to_private.id
  cidr_ipv4         = aws_subnet.private1-euw1a.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}