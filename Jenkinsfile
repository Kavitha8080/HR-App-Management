pipeline {
    agent any

    environment {
        IMAGE_NAME = "hr-app-management"
<<<<<<< HEAD
        DOCKER_HUB_REPO = "Kavitha900/hr-app-management"  // your Docker Hub username
=======
        DOCKER_HUB_REPO = "kavitha900/hr-app-management"  // lowercase username
>>>>>>> 4b4f130 (Fix Docker Hub repo lowercase, update Jenkinsfile)
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
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        
                        # Tagging
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_REPO}:latest
                        
                        # Push
                        docker push ${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                        docker push ${DOCKER_HUB_REPO}:latest
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
                        
                        # Tagging
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${ECR_REPO}:${BUILD_NUMBER}
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${ECR_REPO}:latest
                        
                        # Push
                        docker push ${ECR_REPO}:${BUILD_NUMBER}
                        docker push ${ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo "Cleaning up local images..."
                sh """
                    docker rmi -f ${IMAGE_NAME}:${BUILD_NUMBER} || true
                    docker rmi -f ${DOCKER_HUB_REPO}:${BUILD_NUMBER} || true
                    docker rmi -f ${DOCKER_HUB_REPO}:latest || true
                    docker rmi -f ${ECR_REPO}:${BUILD_NUMBER} || true
                    docker rmi -f ${ECR_REPO}:latest || true
                """
            }
        }

    }

    post {
        success {
            echo "Pipeline completed successfully. Images pushed to Docker Hub and AWS ECR."
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}

