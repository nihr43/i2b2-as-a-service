variable "I2B2_DB_PASS" {}

resource "postgresql_role" "i2b2" {
  name     = "i2b2"
  login    = true
  password = var.I2B2_DB_PASS
}

resource "postgresql_database" "i2b2_crc" {
  name              = "i2b2_crc"
  owner             = "i2b2_crc"
  allow_connections = true
  depends_on  = [postgresql_role.i2b2]
}
