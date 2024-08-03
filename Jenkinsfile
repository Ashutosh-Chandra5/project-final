pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('Ashutosh-temp')
        DOCKERHUB_CREDENTIALS = credentials('79955b39-0d94-430b-bce2-6dd022de88c4')
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone your Git repository
                git url: 'https://github.com/Ashutosh-Chandra5/project-final.git', branch: 'main'
            }
        }

        stage('Create_Infra') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'Ashutosh-temp', variable: 'TKgiu3yUMK3ibd2UwjVU6cOuOszPHVUbPvgAjW3o')]) {
                        sh '''
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
                    withCredentials([usernamePassword(credentialsId: '79955b39-0d94-430b-bce2-6dd022de88c4', usernameVariable: 'kubeashukube', passwordVariable: 'ioaFMLdocker@1234')]) {
                        sh '''
                        docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
                        docker pull your-dockerhub-username/frontend:latest
                        docker pull your-dockerhub-username/backend:latest
                        '''
                    }
                }
                script {
                    sh '''
                    # Assuming the scripts are stored in your repository and are executed using remote-exec provisioners
                    terraform apply -var="frontend_script_path=/path/to/frontend.sh" -var="backend_script_path=/path/to/backend.sh"
                    '''
                }
            }
        }

        stage('Test_Solution') {
            steps {
                script {
                    def frontendIP = sh(script: "terraform output -raw frontend_ip", returnStdout: true).trim()
                    sh "curl http://${frontendIP}:8080" // Adjust port if necessary
                }
            }
        }
    }
}
