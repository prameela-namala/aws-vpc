output "vpc_id" {

    value = aws_vpc.main.id
  
}
output "default_vpc" {
    value = data.aws_vpc.default
}

output "default_aws_route_table" {
  
    value = data.aws_route_table.default 

}
  
output "public_subnet_ids"{
    
    value = aws_subnet.public[*].id
}


output "private_subnet_ids"{
     
     value = aws_subnet.private[*].id
}


output "database_subnet_ids"{
      value = aws_subnet.database[*].id
}
output "database_subnet_group_name" {
    value = aws_db_subnet_group.default.name
  
}