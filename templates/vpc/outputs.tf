output "vpc_tf_id" {
  value = aws_vpc.vpc_tf.id
}

output "vpc_subnets" {
  value = [aws_subnet.sn_one.id, aws_subnet.sn_two.id, aws_subnet.sn_three.id]
}

