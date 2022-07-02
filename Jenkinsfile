pipeline {
  agent any
  stages {
    stage ('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }
     stage ('Terraform apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    
      }
    }
