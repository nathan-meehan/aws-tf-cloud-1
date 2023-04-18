# associating security group w launch template, so we make it twice 
resource "aws_launch_template" "template_tf" {
  name = var.template_name

  image_id = var.image_id

  instance_type = "t2.micro"

  key_name = var.ssh_key_name

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.sg_id]
  }


  user_data = filebase64("${path.module}/web.sh")
}


resource "aws_lb" "lb_tf" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnet_ids

}

resource "aws_lb_target_group" "tg_tf" {
  name     = join("-", [var.asg_name, "tg"])
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_autoscaling_group" "asg_tf" {
  name                      = var.asg_name
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.template_tf.id
    version = "$Latest"
  }

}


resource "aws_autoscaling_attachment" "tf_asg_tg" {
  autoscaling_group_name = aws_autoscaling_group.asg_tf.id
  lb_target_group_arn    = aws_lb_target_group.tg_tf.arn
}

resource "aws_lb_listener" "lb_tf_listener" {
  load_balancer_arn = aws_lb.lb_tf.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_tf.arn
  }
}



