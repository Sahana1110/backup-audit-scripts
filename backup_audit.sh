#!/bin/bash
set -e

DATE=$(date +%Y%m%d)
BACKUP_DIR="/var/backups/git-repos/$DATE"
mkdir -p "$BACKUP_DIR"

REPOS=("repo1" "repo2" "repo3")

for REPO in "${REPOS[@]}"; do
    echo "[$REPO] Pulling latest changes..."
    cd "/tmp/$REPO"

    # Make sure you're on a valid branch before pulling
    BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
    git checkout "$BRANCH" || git checkout main || git checkout master

    git pull origin "$BRANCH" || echo "❌ Pull failed for $REPO"

    echo "[$REPO] Archiving..."
    tar -czf "$REPO-$DATE.tar.gz" "/tmp/$REPO"
    cp "$REPO-$DATE.tar.gz" "$BACKUP_DIR/"
done

# Save audit log
echo "Backup completed on $(date)" > "audit-$DATE.txt"
cp "audit-$DATE.txt" "$BACKUP_DIR/"

# Copy to Jenkins workspace
cp "$BACKUP_DIR/"*.tar.gz .
cp "$BACKUP_DIR/"audit-"$DATE".txt .

echo "✅ Backup complete. Files available in Jenkins workspace."
