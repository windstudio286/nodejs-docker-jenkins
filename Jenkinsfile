pipeline {

    agent none

    environment {
        DOCKER_IMAGE = "ttcong194/node_demo"
    }

    stages {
        stage("build") {
            agent {
                node {
                    label 'master'
                }
            }
            environment {
                DOCKER_TAG = "${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
            }
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                sh "docker image ls | grep ${DOCKER_IMAGE}"
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }

                //clean to save disk
                sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker image rm ${DOCKER_IMAGE}:latest"
            }
        }

        stage("remoteSSH") {
            agent {
                node {
                    label 'master'
                }
            }

            steps {

                withCredentials([sshUserPrivateKey(credentialsId: 'sshUser', keyFileVariable: '', passphraseVariable: 'passWord', usernameVariable: 'userName')]) {

                    script {
                        def remote = [: ]
                        remote.name = "94.237.65.173"
                        remote.host = "94.237.65.173"
                        remote.allowAnyHosts = true
                        echo userName
                        echo passWord
                        remote.user = userName
                        remote.password = passWord
                        sshCommand remote: remote, command: "docker pull ${DOCKER_IMAGE}:latest"
                        sshCommand remote: remote, command: "ls; cd data; ls; docker compose down; docker compose up -d --build"
                        sshCommand remote: remote, command: "docker rmi \$(docker images --filter \"dangling=true\" -q --no-trunc)"
                        //sshCommand remote: remote, command: 'cd data'
                        //sshCommand remote: remote, command: 'ls'
                        //sshCommand remote: remote, command: 'docker compose down'
                        //sshCommand remote: remote, command: 'docker compose up -d --build'
                    }

                }
            }
        }

    }

    post {
        success {
            echo "SUCCESSFUL"
        }
        failure {
            echo "FAILED"
        }
    }
}
