output "algorithm" {
  value = "${tls_private_key.example_ssh.algorithm}"
}

output "private_key_pem" {
  value = "${tls_private_key.example_ssh.private_key_pem}"
  sensitive = true
}

output "public_key_pem" {
  value = "${tls_private_key.example_ssh.public_key_pem}"
}

output "public_key_openssh" {
  value = "${tls_private_key.example_ssh.public_key_openssh}"
}
