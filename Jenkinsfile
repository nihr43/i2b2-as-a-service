pipeline {
   agent any

   stages {
      stage('setup terraform') {
         // terraform statefiles are picky about version, so we pin it in the Makefile
         steps {
            sh 'make terraform'
	    sh 'make .terraform'
         }
      }
      stage('terraform plan') {
         environment {
            TF_VAR_PSQL_PASS    = credentials('TF_VAR_PSQL_PASS')
            TF_VAR_I2B2_DB_PASS = credentials('TF_VAR_I2B2_DB_PASS')
         }
         steps {
            sh 'make plan'
         }
      }
      stage('terraform apply') {
         input {
            message "accept plan?"
            ok "yes"
         }
	 environment {
            TF_VAR_PSQL_PASS    = credentials('TF_VAR_PSQL_PASS')
            TF_VAR_I2B2_DB_PASS = credentials('TF_VAR_I2B2_DB_PASS')
         }
         steps {
           sh 'make force-apply'
         }
      }
      stage('load data') {
        environment {
           TF_VAR_I2B2_DB_PASS = credentials('TF_VAR_I2B2_DB_PASS')
        }
	steps {
           sh '''
             if [ ! -d i2b2-data ] ; then
	       git clone https://github.com/i2b2/i2b2-data.git
	     else
	       git -C i2b2-data pull
	     fi

             cd i2b2-data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata
             echo "
db.type=postgresql
db.username=i2b2
db.password=$TF_VAR_I2B2_DB_PASS
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://postgres-0:5432/i2b2_crc
db.project=demo" > db.properties
             ant -f data_build.xml create_crcdata_tables_release_1-7
	   '''
        }
      }
   }
}
