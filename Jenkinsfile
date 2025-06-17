pipeline {
    agent any

    environment {
        BACKUP_DIR = "/var/backups/git-repos"
        REPO_LIST = "repos.txt"
    }

    stages {
        stage('Run Backup Script') {
            steps {
                sh 'chmod +x backup_audit.sh'
                sh './backup_audit.sh'
            }
        }

        stage('Archive Backups and Logs') {
            steps {
                archiveArtifacts artifacts: '*/.tar.gz, */audit-.txt', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            echo '✅ Backup and audit complete. Check archived artifacts for logs and tar files.'
        }
    }
}
