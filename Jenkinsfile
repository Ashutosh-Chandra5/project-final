pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('Ashutosh-temp') // Replace with your actual credential ID
        DOCKER_IMAGE_FRONTEND = 'kubeashukube/frontend:latest'
        DOCKER_IMAGE_BACKEND = 'kubeashukube/backend:latest'
    }

    stages {
        stage('Create_Infra') {
            steps {
                script {
                    // Clone the repository containing Terraform scripts
                    git url: 'https://github.com/Ashutosh-Chandra5/project-final.git', branch: 'main'
                    
                    // Initialize and apply Terraform
                    withCredentials([string(credentialsId: 'terraform-token-id', variable: 'TF_TOKEN')]) {
                        sh '''
                        cd terraform
                        terraform init
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Deploy_Apps') {
            steps {
                script {
                    // Use Terraform provisioners to execute the scripts
                    sh '''
                    cd terraform
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Test_Solution') {
            steps {
                script {
                    // Test if the frontend is accessible
                    sh '''
                    FRONTEND_IP=$(terraform output -raw frontend_ip)
                    curl http://$FRONTEND_IP
                    '''
                }
            }
        }
    }
}
