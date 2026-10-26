resource "aws_security_group" "compute_sg" {
  name        = "compute-tier-sg"
  description = "Private application compute tier"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "rds_sg" {
  name        = "isolated-rds-sg"
  description = "Strict 3306 ingress from Compute SG only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.compute_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
