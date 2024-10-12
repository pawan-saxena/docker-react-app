pipeline {
    // agent {
    //     docker {
    //         image 'node:16-alpine'
    //         label 'docker'
    //         args '-v /var/run/docker.sock:/var/run/docker.sock'
    //     }
    // }
    agent any

    environment {
        DOCKER_TEST_IMAGE = 'saxenapawan800/docker-react-app-tests'
        DOCKER_PROD_IMAGE = 'saxenapawan800/docker-react-app'
    }

    stages {
        stage('Checkout code') {
            steps {
                git branch: 'master', url: 'https://github.com/pawan-saxena/docker-react-app'
            }
        }

        // stage("Install Dependencies") {
        //     steps {
        //         script {
        //             sh "npm run install"
        //         }
        //     }
        // }

        stage('Build Docker Tests Image') {
            steps {
                script {
                    sh 'docker build -f Dockerfile.dev -t $DOCKER_TEST_IMAGE .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'docker run -e CI=true $DOCKER_TEST_IMAGE npm run test'
                }
            }
        }

        stage('Build Docker Nginx Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_PROD_IMAGE .'
                }
            }
        }

        stage('Start Application..') {
            steps {
                script {
                    sh 'docker run -d -p 80:80 $DOCKER_PROD_IMAGE'
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f'
        }
    }
}
