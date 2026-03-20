pipeline {
agent any

```
environment {
    IMAGE_NAME = "jattin11/my-python-app"
    TAG = "latest"
}

stages {

    stage('Clone Code') {
        steps {
            git 'https://github.com/your-repo/python-project.git'
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
            sh 'docker run -d -p 5001:5000 --name test-container $IMAGE_NAME:$TAG'
            sh 'sleep 5'
            sh 'curl http://localhost:5001'
            sh 'docker rm -f test-container'
        }
    }

    stage('Scan Image') {
        steps {
            sh 'trivy image $IMAGE_NAME:$TAG'
        }
    }

    stage('Push to Docker Hub') {
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
```

}
