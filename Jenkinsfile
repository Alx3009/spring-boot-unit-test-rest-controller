pipeline {
  agent any
  tools {
    maven 'Maven 3.8.8'
    jdk 'Temurin JDK 17'
  }

  environment {
    SONARQUBE_SERVER = 'SonarQube'
    IMAGE_NAME = 'qrisss/cicd-learning'
    IMAGE_TAG = 'latest'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/jimash974/CI-CD-Learning', branch: 'main'
      }
    }

    stage('Unit Test & Coverage') {
      steps {
        sh 'mvn package'
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
        }
      }
    }

    stage('Static Code Analysis (SAST) via SonarQube') {
      steps {
        sh """
          mvn clean verify sonar:sonar \
            -Dsonar.projectKey=CICD-Learning \
            -Dsonar.projectName='CICD Learning' \
            -Dsonar.host.url=http://sonarqube:9000 \
            -Dsonar.token=sqp_448a81b21a982479d58bedcd8007cb7f17b0ead6
        """
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
            def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
            image.push()
          }
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline berhasil 🚀"
    }
    failure {
      echo "Pipeline gagal 💥"
    }
  }
}