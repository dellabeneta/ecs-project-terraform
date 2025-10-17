# --- Elastic IP for NAT Gateway ---
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "ecs-demo-nat-eip"
  }
}

# --- NAT Gateway ---
# Colocado em uma sub-rede pública para ter acesso à internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "ecs-demo-nat-gw"
  }

  # Garante que o IGW esteja de pé antes de criar o NAT GW
  depends_on = [aws_internet_gateway.main]
}
