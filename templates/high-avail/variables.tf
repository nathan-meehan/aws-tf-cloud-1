variable "vpc_id" {}
variable "image_id" {}
variable "sg_id" {}
variable "ssh_key_name" {}
variable "subnet_ids" {
    type = list(string)
}
variable "template_name" {
    default = "tf-image-template"
}
variable "asg_name" {
    default = "tf-asg"
}
variable "lb_name" {
    default = "tf-lb"
}


