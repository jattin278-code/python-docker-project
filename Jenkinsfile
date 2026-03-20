pipeline {
    agent any

    environment {
        IMAGE_NAME = "jattin278-code/python-app"
        TAG = "${BUILD_NUMBER}"
        DOCKER_HUB_USER = "jattin11" // Defined for clarity
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Base Image') {
            steps {
                // Ensure Dockerfile.base includes: RUN useradd -m appuser
                sh 'docker build -t my-python-base:1.0 -f Dockerfile.base .'
            }
        }

        stage('Build App Image') {
            steps {
                // Ensure your Dockerfile adds the PATH: ENV PATH="/home/appuser/.local/bin:${PATH}"
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Run Container Test') {
            steps {
                sh '''
                docker rm -f test-container || true
                # FIX: Use $IMAGE_NAME:$TAG instead of hardcoded :8
                docker run -d -p 5001:5000 --name test-container $IMAGE_NAME:$TAG
                sleep 10
                curl --retry 5 --retry-delay 2 --fail http://localhost:5001/ || (docker logs test-container && exit 1)
                '''
            }
        }

        stage('Scan Image') {
            steps {
                // Scans the image built in this specific run
                sh 'trivy image $IMAGE_NAME:$TAG'
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    // Use the variables USER and PASS defined above
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $IMAGE_NAME:$TAG'
                }
            }
        }
    }

    post {
        always {
            // Clean up the test container regardless of success or failure
            sh 'docker rm -f test-container || true'
        }
        success {
            echo "Build and Deployment successful: $IMAGE_NAME:$TAG"
        }
        failure {
            echo "Build failed - check Docker logs or PATH settings."
        }
    }
}
