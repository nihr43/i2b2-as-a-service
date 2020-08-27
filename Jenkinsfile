pipeline {
   agent any

   stages {
      stage('fetch terraform') {
         // terraform statefiles are picky about version, so we pin it here
         steps {
            sh '''
	      if [ ! -f terraform ] ; then
                wget -O- https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip | unzip -
              done
	      chmod +x terraform
	      ./terraform -version
            '''
         }
      }
   }
}
