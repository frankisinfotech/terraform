pipeline {
  agent any
  stages {
    stage ('Terraform Init') {
      steps {
        withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"]) {
        sh 'cd /var/lib/jenkins/workspace/terra-deploy/ec2'
        sh 'terraform init'
      }
    }
    }
     stage ('Terraform apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    
      }
    }
