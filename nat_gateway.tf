resource "aws_eip" "nat_ip" {
    tags = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateway" "NATgw" {
  allocation_id = "${aws_eip.nat_ip.id}"
  subnet_id     = "${aws_subnet.first_subnet.id}"

  tags = {
    Name = "nat_gw"
  }
}

resource "aws_route_table" "Nat_RT" {
  vpc_id = aws_vpc.my_vpc_cre.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "NAT_RT"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
    aws_nat_gateway.NATgw,
  ]
}

//////////////////////////////////RT association with subnet1
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.Nat_RT.id
  depends_on = [
    aws_subnet.second_subnet,
    aws_route_table.Nat_RT,
  ]
}