properties([
  // https://github.com/jenkinsci/pipeline-model-definition-plugin/wiki/Parametrized-pipelines
  parameters([
    booleanParam(name: 'reprovision_database', defaultValue: true)
  ])
])

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
      when {
        environment name: 'reprovision_database', value: 'true'
      }
      environment {
        TF_VAR_PSQL_PASS    = credentials('TF_VAR_PSQL_PASS')
        TF_VAR_I2B2_DB_PASS = credentials('TF_VAR_I2B2_DB_PASS')
      }
      steps {
        sh './terraform taint postgresql_database.i2b2_crc'
        sh 'make plan'
      }
    }
    stage('terraform apply') {
      when {
        environment name: 'reprovision_database', value: 'true'
      }
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
    stage('load i2b2-data') {
      when {
        environment name: 'reprovision_database', value: 'true'
      }
      environment {
        TF_VAR_I2B2_DB_PASS = credentials('TF_VAR_I2B2_DB_PASS')
      }
      steps {
        sh 'make i2b2'
      }
    }
  }
}
