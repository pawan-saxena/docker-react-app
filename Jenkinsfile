pipeline {

    agent any
    
    environment {
        DOCKER_PROD_IMAGE = 'saxenapawan800/docker-react-app'
        AWS_REGION = 'us-east-1'
        EB_APP_NAME = 'docker-react-app'
        EB_ENV_NAME = 'Docker-react-app-env'
        S3_BUCKET = 'elasticbeanstalk-us-east-1-869935086562'
        AWS_ACCESS_KEY_ID = credentials('AWSAccessKeyId')
        AWS_SECRET_ACCESS_KEY = credentials('AWSSecretKey')
    }

    stages {
        stage('Checkout code') {
            steps {
                git branch: 'master', url: 'https://github.com/pawan-saxena/docker-react-app'
            }
        }

        stage('Build Docker Nginx Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_PROD_IMAGE} ."
                }
            }
        }

        stage('Create Dockerrun.aws.json') {
            steps {
                script {
                    writeFile file: 'Dockerrun.aws.json', text: """{
                        "AWSEBDockerrunVersion": "1",
                        "Image": {
                            "Name": "${DOCKER_PROD_IMAGE}",
                            "Update": "true"
                        },
                        "Ports": [
                            {
                                "ContainerPort": "80"
                            }
                        ]
                    }"""

                    sh 'zip -r deployment.zip Dockerrun.aws.json'
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    sh 'aws s3 cp deployment.zip s3://$S3_BUCKET/$EB_APP_NAME/deployment-$BUILD_NUMBER.zip'
                    sh 'eb init $EB_APP_NAME --region $AWS_REGION'
                    sh 'eb deploy $EB_ENV_NAME --staged'
                }
            }
        }
    }

    // post {
    //     always {
    //         // sh 'docker system prune -f'
    //     }
    // }
}
