pipeline {
    agent any

    environment {
        IMAGE_NAME = "jattin278-code/python-app"
        TAG = "${BUILD_NUMBER}"
    }

    stages {

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
        docker run -d -p 5001:5000 --name test-container jattin278-code/python-app:8
        sleep 10
        curl --retry 5 --retry-delay 2 --fail http://localhost:5001
        '''
    }
}

        stage('Scan Image') {
            steps {
                sh 'trivy image $IMAGE_NAME:$TAG'
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'jattin11',
                    passwordVariable: 'Admin@123'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $IMAGE_NAME:$TAG'
                }
            }
        }
    }

    post {
        success {
            echo "Build successful"
        }
        failure {
            echo "Build failed"
        }
    }
}
