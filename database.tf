resource "aws_kms_key" "rds_encryption_key" {
  description             = "CMK for RDS encryption at rest"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/blast-radius-zero-rds-key"
  target_key_id = aws_kms_key.rds_encryption_key.key_id
}

resource "aws_db_instance" "secure_database" {
  identifier                  = "secure-core-db"
  engine                      = "mysql"
  instance_class              = "db.t4g.micro"
  allocated_storage           = 20
  username                    = "db_admin"
  manage_master_user_password = true
  db_subnet_group_name        = module.vpc.database_subnet_group_name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  storage_encrypted           = true
  kms_key_id                  = aws_kms_key.rds_encryption_key.arn
  publicly_accessible         = false
  skip_final_snapshot         = true
}

resource "aws_secretsmanager_secret_rotation" "rds_password_rotation" {
  secret_id = aws_db_instance.secure_database.master_user_secret[0].secret_arn
  rotation_rules {
    automatically_after_days = 30
  }
}
