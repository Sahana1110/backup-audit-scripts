#!/bin/bash

# Date format
DATE=$(date +%Y%m%d)

# Directories
BACKUP_DIR="/var/backups/git-repos/$DATE"
REPOS=(repo1 repo2 repo3)

# Make backup directory
mkdir -p "$BACKUP_DIR"

# Loop through repos
for REPO in "${REPOS[@]}"; do
    echo "[$REPO] Pulling latest changes..."
    
    # Clone or update repo
    if [ -d "/tmp/$REPO/.git" ]; then
        cd "/tmp/$REPO" || exit
        git pull
    else
        git clone "https://github.com/Sahana1110/$REPO.git" "/tmp/$REPO"
        cd "/tmp/$REPO" || exit
    fi

    # Fix dubious ownership (safe.directory)
    git config --global --add safe.directory "/tmp/$REPO"

    # Archive the repo
    echo "[$REPO] Archiving..."
    tar -czf "$BACKUP_DIR/$REPO-$DATE.tar.gz" "/tmp/$REPO"

    # Add audit log
    echo "[$REPO] Backup: $REPO-$DATE.tar.gz" >> "$BACKUP_DIR/audit-$DATE.txt"
    echo "[$REPO] Commit: $(git log -1 --pretty=format:'%h - %s (%ci)')" >> "$BACKUP_DIR/audit-$DATE.txt"
    echo "------------------------------" >> "$BACKUP_DIR/audit-$DATE.txt"
done

# Copy artifacts back to Jenkins workspace
cp "$BACKUP_DIR"/*.tar.gz .
cp "$BACKUP_DIR"/audit-*.txt .

echo "✅ Backup complete. Stored in $BACKUP_DIR"
