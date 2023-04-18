resource "aws_security_group" "tf_sg" {
  name        = join("-", ["allow-http-ssh", var.vpc_id])
  description = "Allow HTTP and SSH inbound traffic, allow all out"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from all"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}