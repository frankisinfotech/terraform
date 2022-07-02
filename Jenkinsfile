pipeline {
  agent any
  stages {
    stage ('Terraform Init') {
      steps {
        sh 'cd /var/lib/jenkins/workspace/terra-deploy/ec2'
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
