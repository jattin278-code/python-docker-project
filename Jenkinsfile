pipeline {
    agent any

    environment {
        IMAGE_NAME = "jattin278-code/python-app"
        TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Base Image') {
            steps {
                sh 'docker build -t my-python-base:1.0 -f Dockerfile.base .'
            }
        }

        stage('Build App Image') {
            steps {
                // Force rebuild to avoid cache issues
                sh 'docker build --no-cache -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Run Container Test') {
            steps {
                sh '''
                docker rm -f test-container || true

                docker run -d -p 5001:5000 --name test-container $IMAGE_NAME:$TAG

                echo "Waiting for application to be ready..."

                # Retry loop instead of fixed sleep
                for i in {1..10}; do
                    if curl -s http://localhost:5001/ > /dev/null; then
                        echo "App is up!"
                        break
                    fi
                    echo "Still starting..."
                    sleep 3
                done

                # Final check (fail if not reachable)
                curl --fail http://localhost:5001/ || (docker logs test-container && exit 1)
                '''
            }
        }

        stage('Scan Image') {
            steps {
                sh 'trivy image --no-progress $IMAGE_NAME:$TAG'
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME:$TAG
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker rm -f test-container || true'
        }
        success {
            echo "✅ Build & Push Successful: $IMAGE_NAME:$TAG"
        }
        failure {
            echo "❌ Build failed - check logs above."
        }
    }
}
