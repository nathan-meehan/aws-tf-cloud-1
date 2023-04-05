resource "aws_instance" "tf_vm_priv" {
  ami                    = "ami-00c39f71452c08778"
  instance_type          = "t2.micro"
  subnet_id              = var.sn_pub_id
  vpc_security_group_ids = [var.sg_id]
  key_name = "nathan-m-kp"
  user_data              = <<EOF
#!/bin/bash
yum install docker -y
usermod -aG docker ec2-user
docker run -iTd --name W1 -p 8080:80 nginx:latest
EOF
}