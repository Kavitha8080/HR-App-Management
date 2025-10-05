pipeline {
    agent any

    environment {
        IMAGE_NAME = "hr-app-management"
        DOCKER_HUB_REPO = "Kavitha8080/hr-app-management"  // your Docker Hub username
        ECR_REPO = "259778757673.dkr.ecr.us-east-1.amazonaws.com/hr-app-management"
        AWS_REGION = "us-east-1"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                git branch: 'master', url: 'https://github.com/Kavitha8080/HR-App-Management.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                                  usernameVariable: 'DOCKER_USER', 
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "Logging into Docker Hub..."
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                        docker push ${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh """
                        echo "Logging into AWS ECR..."
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${ECR_REPO}:${BUILD_NUMBER}
                        docker push ${ECR_REPO}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo "Cleaning up local images..."
                sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
                sh "docker rmi ${DOCKER_HUB_REPO}:${BUILD_NUMBER} || true"
                sh "docker rmi ${ECR_REPO}:${BUILD_NUMBER} || true"
            }
        }

    }

    post {
        success {
            echo "Pipeline completed successfully. Image pushed to Docker Hub and AWS ECR."
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
