pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Backup Script') {
            steps {
                sh 'chmod +x backup_audit.sh'
                sh './backup_audit.sh'
            }
        }

        stage('Archive Backups and Logs') {
            steps {
                archiveArtifacts artifacts: '*.tar.gz, audit-.txt', onlyIfSuccessful: true
            }
        }
    }

    post {
        always {
            echo '✅ Backup and audit complete. Check archived artifacts.'
        }
    }
}
