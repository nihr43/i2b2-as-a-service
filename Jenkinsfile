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
         steps {
            sh 'make plan'
         }
      }
   }
}
