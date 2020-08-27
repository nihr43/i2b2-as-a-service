provider "postgresql" {
  host            = "postgres-0"
  port            = 5432
  database        = "postgres"
  username        = "terraform"
  password        = var.PSQL_PASS
  sslmode         = "disable"
  connect_timeout = 15
}
