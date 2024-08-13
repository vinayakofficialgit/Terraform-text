output "pub_subnet" {
  value = aws_subnet.public[*].id   
}

output "id_sgrp" {
  value = aws_security_group.mysg.id
}
