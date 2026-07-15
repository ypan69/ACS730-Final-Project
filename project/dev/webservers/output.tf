# Step 10 - Add output variables
output "launch_template_id" {
  value = module.webservers.launch_template_id
}

output "bastion_public_ip" {
  value = module.webservers.bastion_public_ip
}

output "web_sg_id" {
  value = module.webservers.web_sg_id
}

output "alb_sg_id" {
  value = module.webservers.alb_sg_id
}

output "bastion_sg_id" {
  value = module.webservers.bastion_sg_id
}