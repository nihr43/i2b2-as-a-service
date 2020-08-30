#!/bin/sh

set -euxo pipefail
hash pg_dump pigz

export PGPASSWORD="$TF_VAR_I2B2_DB_PASS"
pg_dump -h "$DB_HOST" -U i2b2 i2b2 | pigz -9 > i2b2.sql.gz
