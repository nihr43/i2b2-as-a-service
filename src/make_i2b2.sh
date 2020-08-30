#!/bin/sh

set -euxo pipefail
hash git ant

if [ ! -d i2b2-data ] ; then
  git clone https://github.com/i2b2/i2b2-data.git
else
  git -C i2b2-data pull
fi

homedir="$(pwd)"

# db.properties template sans jdbc string
cat > db.properties << EOF
db.type=postgresql
db.username=i2b2
db.password=${TF_VAR_I2B2_DB_PASS}
db.driver=org.postgresql.Driver
db.project=demo
EOF

# load crc
cd "${homedir}"/i2b2-data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata
cp "${homedir}"/db.properties .
echo "db.url=jdbc:postgresql://${DB_HOST}/i2b2?currentSchema=crc" >> db.properties
ant -f data_build.xml create_crcdata_tables_release_1-7
ant -f data_build.xml create_procedures_release_1-7
if [ "$load_demodata" == "true" ] ; then
  ant -f data_build.xml db_demodata_load_data
fi

# load hive
cd "${homedir}"/i2b2-data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Hivedata
cp "${homedir}"/db.properties .
echo "db.url=jdbc:postgresql://${DB_HOST}/i2b2?currentSchema=hive" >> db.properties
ant -f data_build.xml create_hivedata_tables_release_1-7
if [ "$load_demodata" == "true" ] ; then
 ant -f data_build.xml db_hivedata_load_data
fi

# load metadata
cd "${homedir}"/i2b2-data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Metadata
cat > db.properties << EOF
db.type=postgresql
db.username=i2b2
db.password=${TF_VAR_I2B2_DB_PASS}
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://${DB_HOST}/i2b2?currentSchema=metadata
db.project=demo
db.dimension=OBSERVATION_FACT
db.schemaname=I2B2DEMODATA
EOF
ant -f data_build.xml create_metadata_tables_release_1-7
ant -f data_build.xml create_metadata_procedures_release_1-7
ant -f data_build.xml db_metadata_run_total_count_postgresql
if [ "$load_demodata" == "true" ] ; then
  ant -f data_build.xml db_metadata_load_identified_data
  ant -f data_build.xml db_metadata_load_data
fi

# load pmdata
cd "${homedir}"/i2b2-data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Pmdata
cp "${homedir}"/db.properties .
echo "db.url=jdbc:postgresql://${DB_HOST}/i2b2?currentSchema=pm" >> db.properties
ant -f data_build.xml create_pmdata_tables_release_1-7
ant -f data_build.xml create_triggers_release_1-7
if [ "$load_demodata" == "true" ] ; then
  ant -f data_build.xml db_pmdata_load_data
fi

# load workdata
cd "${homedir}"/i2b2-data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Workdata
cp "${homedir}"/db.properties .
echo "db.url=jdbc:postgresql://${DB_HOST}/i2b2?currentSchema=workdata" >> db.properties
ant -f data_build.xml create_workdata_tables_release_1-7
if [ "$load_demodata" == "true" ] ; then
  ant -f data_build.xml db_workdata_load_data
fi
