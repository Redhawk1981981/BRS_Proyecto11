output "victim_ip" {
  value = aws_instance.victim.private_ip
}
output "attacker_ip" {
  value = aws_instance.attacker.public_ip
}
