variable "I2B2_DB_PASS" {}

resource "postgresql_role" "i2b2" {
  name     = "i2b2"
  login    = true
  password = var.I2B2_DB_PASS
}

resource "postgresql_database" "i2b2" {
  name              = "i2b2"
  owner             = "i2b2"
  allow_connections = true
  depends_on  = [postgresql_role.i2b2]
}

resource "postgresql_schema" "crc" {
  depends_on = [postgresql_database.i2b2]
  name       = "crc"
  owner      = "i2b2"
  database   = "i2b2"
  policy {
    create = true
    usage  = true
    role   = "${postgresql_role.i2b2.name}"
  }
}

resource "postgresql_schema" "hive" {
  depends_on = [postgresql_database.i2b2]
  name       = "hive"
  owner      = "i2b2"
  database   = "i2b2"
  policy {
    create = true
    usage  = true
    role   = "${postgresql_role.i2b2.name}"
  }
}

resource "postgresql_schema" "metadata" {
  depends_on = [postgresql_database.i2b2]
  name       = "metadata"
  owner      = "i2b2"
  database   = "i2b2"
  policy {
    create = true
    usage  = true
    role   = "${postgresql_role.i2b2.name}"
  }
}

resource "postgresql_schema" "pm" {
  depends_on = [postgresql_database.i2b2]
  name       = "pm"
  owner      = "i2b2"
  database   = "i2b2"
  policy {
    create = true
    usage  = true
    role   = "${postgresql_role.i2b2.name}"
  }
}

resource "postgresql_schema" "workdata" {
  depends_on = [postgresql_database.i2b2]
  name       = "workdata"
  owner      = "i2b2"
  database   = "i2b2"
  policy {
    create = true
    usage  = true
    role   = "${postgresql_role.i2b2.name}"
  }
}
