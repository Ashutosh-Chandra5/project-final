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
                git url: 'https://github.com/Ashutosh-Chandra5/project-final.git', branch: 'master'
            }
        }

        stage('Create_Infra') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Ashutosh-temp', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
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
                    withCredentials([usernamePassword(credentialsId: '79955b39-0d94-430b-bce2-6dd022de88c4', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker pull your-dockerhub-username/frontend:latest
                        docker pull your-dockerhub-username/backend:latest
                        '''
                    }
                }
                script {
                    sh '''
                    terraform apply -auto-approve -var="frontend_script_path=path/to/frontend.sh" -var="backend_script_path=path/to/backend.sh"
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
