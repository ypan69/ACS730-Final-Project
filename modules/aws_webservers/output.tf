# Step 10 - Add output variables
output "launch_template_id" {
  value = aws_launch_template.my_amazon.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web_sg_id" {
  value = module.sg.web_sg_id
}

output "alb_sg_id" {
  value = module.sg.alb_sg_id
}

output "bastion_sg_id" {
  value = module.sg.bastion_sg_id
}