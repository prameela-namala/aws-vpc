output "vpc_id" {

    value = aws_vpc.main.id
  
}
output "default_vpc" {
    value = data.aws_vpc.default
}

output "default_aws_route_table" {
  
    value = data.aws_route_table.default 

}