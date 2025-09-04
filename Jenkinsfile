pipeline {
    agent {
        label 'salvee'  // Remplacez par le label de votre agent slave
    }

    environment {
        REGISTRY_PROJECT = 'registry.gitlab.com/benabbes.mohamedaziz30/jenkinstest/netflix-medazizbenabbes'
        IMAGE = "${REGISTRY_PROJECT}:version-${BUILD_ID}"
        TMDB_KEY = "93f33e69782099576b43798ad8e18d29"
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/azizbenabbes/DevSecOpsProject-Netflix.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sq2') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=netflix-clone \
                        -Dsonar.projectName="Netflix Clone" \
                        -Dsonar.sources=.
                    '''
                }

                // Archiver le rapport
                archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
            }
        }

        stage('Build') {
            steps {
                script {
                    def img = docker.build("${IMAGE}", " --build-arg TMDB_V3_API_KEY=${TMDB_KEY} .")
                    env.DOCKER_IMAGE = img.id
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh '''
                    echo "Scanning Docker image: ${IMAGE}"
                    trivy image --format table --no-progress ${IMAGE}

                    # Générer un rapport JSON
                    trivy image --format json --output trivy-report.json ${IMAGE}

                    # Vérifier les vulnérabilités critiques et élevées
                    echo "Checking for HIGH and CRITICAL vulnerabilities..."
                    trivy image --severity HIGH,CRITICAL --exit-code 1 ${IMAGE}
                '''

                // Archiver le rapport
                archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
            }
        }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.gitlab.com', 'reg1') {
                        def img = docker.image("${IMAGE}")
                        img.push('latest')
                        img.push()
                    }
                }
            }
        }

        stage('Update ArgoCD Deployment') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                        # Config Git
                        git config --global user.name "Jenkins-CI"
                        git config --global user.email "jenkins@ci.local"

                        # Nettoyer ancien clone
                        rm -rf argocd-repo

                        # Clone sécurisé
                        git clone https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/azizbenabbes/DevSecOpsProject-Netflix.git argocd-repo
                        cd argocd-repo

                        # Mettre à jour le tag de l'image
                        sed -i "s|registry.gitlab.com/benabbes.mohamedaziz30/jenkinstest/netflix-medazizbenabbes:.*|registry.gitlab.com/benabbes.mohamedaziz30/jenkinstest/netflix-medazizbenabbes:version-${BUILD_ID}|g" argocd/dep.yml

                        # Vérifier changement
                        echo "Updated deployment file:"
                        grep "image:" argocd/dep.yml

                        # Commit & push
                        git add argocd/dep.yml
                        git commit -m "Update image tag to version-${BUILD_ID} - Build #${BUILD_ID}"
                        git push origin main

                        echo "Successfully updated deployment file to version-${BUILD_ID}"
                    '''
                }
            }
        }
    }

    post {
        always {
            // Nettoyer images Docker locales
            sh 'docker system prune -f'
        }
        success {
            echo "✅ Pipeline completed successfully! Image pushed: ${IMAGE}"
        }
        failure {
            echo "❌ Pipeline failed! Check the logs for details."
        }
    }
}
