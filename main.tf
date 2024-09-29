# creating vpc

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames


  tags = merge(
   var.common_tags,

   var.vpc_tags,
   {

    Name = local.resource_name
   }

  )
}

#creating internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(

    var.common_tags,
    var.igw_tags,
    {
       Name = local.resource_name
    }
  )
}

#creating public subnet

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)  
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidr[count.index]



  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
        Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}



#creating private subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)  
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block = var.private_subnet_cidr[count.index]



  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
        Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

#creating database subnet

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)  
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block = var.database_subnet_cidr[count.index]



  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
        Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

#creating RDS database subnet group

resource "aws_db_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
     
     var.common_tags,
     var.db_subnet_group_tags,
     {
        Name = local.resource_name

     }


    )
  
}
# creating elastic ip
resource "aws_eip" "nat" {
  domain   = "vpc"
}

#creating nat gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(

    var.common_tags,
    var.aws_nat_gateway_tags,
    {
     
      Name = local.resource_name

    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

#creating route table for public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {

      Name = "${local.resource_name}-public" #expense-dev-public
    }

  )
}

#creating route table for private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {

      Name = "${local.resource_name}-private" #expense-dev-public
    }

  )
}

#creating route table for database
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {

      Name = "${local.resource_name}-database" #expense-dev-public
    }

  )
}
#adding routes to public

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0" #for public we give igw
  gateway_id = aws_internet_gateway.igw.id

}

#adding routes to private

resource "aws_route" "private_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0" 
  gateway_id = aws_nat_gateway.main.id

}

#adding routes to database

resource "aws_route" "database_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0" #for public we give igw
  gateway_id = aws_nat_gateway.main.id

}

#associating public routes to routetable
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
#associating private routes to routetable
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
#associating database routes to routetable
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

