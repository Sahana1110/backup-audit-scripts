pipeline {
    agent any

    environment {
        TODAY = new Date().format('yyyyMMdd')
        BACKUP_DIR = "${env.WORKSPACE}/git-repo-backups/${TODAY}"
    }

    stages {
        stage('Clone Backup Script Repo') {
            steps {
                git 'https://github.com/Sahana1110/backup-audit-scripts.git'
            }
        }

        stage('Run Backup Script') {
            steps {
                sh '''
                    chmod +x backup_audit.sh
                    ./backup_audit.sh
                '''
            }
        }

        stage('Archive Backups and Logs') {
            steps {
                archiveArtifacts artifacts: 'git-repo-backups/*/', fingerprint: true
            }
        }
    }

    post {
        always {
            echo "✅ Backup and audit complete. Check archived artifacts for logs and tar files."
        }
    }
}
