pipeline {
   agent any

   stages {
      stage('Hello') {
         steps {
            sh '''
              export DOCKER_HOST=ssh://root@docker-0
              docker run hashicorp/terraform:0.12.24 -version
            '''
         }
      }
   }
}
