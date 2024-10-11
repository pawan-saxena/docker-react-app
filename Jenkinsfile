pipeline {
    agent{
        docker {
            image "node:16-alpine"
            label "docker"
            args "-v /var/run/docker.sock:/var/run/docker.sock"
        }
    }

    environment {
        DOCKER_TEST_IMAGE = "saxenapawan800/docker-react-app-tests"
        DOCKER_PROD_IMAGE = "saxenapawan800/docker-react-app"
    }

    stages{

        stage("Checkout code") {
            steps {
                git branch: "master", url: "https://github.com/pawan-saxena/docker-react-app"
            }
        }

        // stage("Install Dependencies") {
        //     steps {
        //         script {
        //             sh "npm run install"
        //         }
        //     }
        // }

        stage("Build Docker Tests Image") {
            script {
                sh "docker build -f Dockerfile.dev -t $DOCKER_TEST_IMAGE ."
            }
        }

        stage("Run Tests") {
            script {
                sh "docker run -e CI=true $DOCKER_TEST_IMAGE npm run test"
            }
        }

        stage("Build Docker Nginx Image") {
            script {
                sh "docker build -t $DOCKER_PROD_IMAGE ."
            }
        }

        stage("Start Application") {
            steps {
                script {
                    sh "docker run -d -p 3000:3000 $DOCKER_PROD_IMAGE"
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker system prune -f"
            }
        }
    }
}