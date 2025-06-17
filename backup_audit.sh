#!/bin/bash

DATE=$(date +%Y%m%d)
BACKUP_DIR="/var/backups/git-repos/$DATE"
REPOS=(repo1 repo2 repo3)

mkdir -p "$BACKUP_DIR"

for REPO in "${REPOS[@]}"; do
    echo "[$REPO] Pulling latest changes..."

    if [ -d "/tmp/$REPO/.git" ]; then
        cd "/tmp/$REPO" || exit
        git config --global --add safe.directory "/tmp/$REPO"
        git pull || echo "❌ Pull failed for $REPO"
    else
        git clone "https://github.com/Sahana1110/$REPO.git" "/tmp/$REPO"
        cd "/tmp/$REPO" || exit
    fi

    echo "[$REPO] Archiving..."
    tar -czf "$BACKUP_DIR/$REPO-$DATE.tar.gz" "/tmp/$REPO"

    echo "[$REPO] Backup: $REPO-$DATE.tar.gz" >> "$BACKUP_DIR/audit-$DATE.txt"
    echo "[$REPO] Commit: $(git log -1 --pretty=format:'%h - %s (%ci)')" >> "$BACKUP_DIR/audit-$DATE.txt"
    echo "------------------------------" >> "$BACKUP_DIR/audit-$DATE.txt"
done

# Copy to Jenkins workspace for archiving
cp "$BACKUP_DIR"/*.tar.gz "$WORKSPACE"/ || echo "❌ Copy tar failed"
cp "$BACKUP_DIR"/audit-*.txt "$WORKSPACE"/ || echo "❌ Copy audit failed"

echo "✅ Backup complete. Files available in Jenkins workspace."
