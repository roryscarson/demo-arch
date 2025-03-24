resource "aws_lb" "main_lb" {
  name               = "demo-arch-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.internet_to_alb.id,
    aws_security_group.internet_to_k8s.id,
    aws_security_group.public_to_private.id
  ]
  subnets = [
    aws_subnet.public1-euw1a.id,
    aws_subnet.public2-euw1b.id,
    aws_subnet.public3-euw1c.id
  ]

    enable_deletion_protection = true

    access_logs {
     bucket  = aws_s3_bucket.secure_bucket.id
     prefix  = "demo_arch_lb"
     enabled = true
    }
}