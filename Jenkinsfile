pipeline {
   agent any

   stages {
      stage('fetch terraform') {
         // terraform statefiles are picky about version, so we pin it in the Makefile
         steps {
            sh 'make terraform'
         }
      }
      stage('terraform init') {
         steps {
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
         steps {
           sh 'make plan'
         }
      }
   }
}
