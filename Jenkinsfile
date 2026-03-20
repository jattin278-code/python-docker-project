pipeline {
    agent any

    environment {
        IMAGE_NAME = "jattin278-code/python-app"
        TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
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
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Run Container Test') {
            steps {
                sh '''
                docker rm -f test-container || true

                docker run -d --network host --name test-container $IMAGE_NAME:$TAG

                echo "Waiting for application..."

                for i in {1..10}; do
                  if curl -s http://localhost:5000/ > /dev/null; then
                    echo "✅ App is up!"
                    break
                  fi
                  echo "⏳ Still starting..."
                  sleep 3
                done

                curl --fail http://localhost:5000/ || (echo "❌ App failed" && docker logs test-container && exit 1)
                '''
            }
        }

        stage('Scan Image (Trivy)') {
            steps {
                sh 'trivy image $IMAGE_NAME:$TAG'
            }
        }

        stage('Push to DockerHub') {
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
            echo "✅ Build Successful: $IMAGE_NAME:$TAG"
        }
        failure {
            echo "❌ Build Failed - Check logs above"
        }
    }
}
