#!/bin/bash

TODAY=$(date +%Y%m%d)
BACKUP_DIR="/var/backups/git-repos/$TODAY"
LOG_FILE="$BACKUP_DIR/audit-$TODAY.txt"
REPO_LIST="repos.txt"

mkdir -p "$BACKUP_DIR"

while read -r REPO_URL; do
    REPO_NAME=$(basename "$REPO_URL" .git)
    LOCAL_DIR="/tmp/$REPO_NAME"

    if [ -d "$LOCAL_DIR/.git" ]; then
        echo "[$REPO_NAME] Pulling latest changes..."
        cd "$LOCAL_DIR" && git pull
    else
        echo "[$REPO_NAME] Cloning fresh..."
        git clone "$REPO_URL" "$LOCAL_DIR"
    fi

    echo "[$REPO_NAME] Archiving..."
    tar -czf "$BACKUP_DIR/${REPO_NAME}-$TODAY.tar.gz" -C "$LOCAL_DIR" .

    echo "=== Commits for $REPO_NAME (last 1 day) ===" >> "$LOG_FILE"
    cd "$LOCAL_DIR"
    git log --since=1.day >> "$LOG_FILE"
    echo "------------------------------------------" >> "$LOG_FILE"
done < "$REPO_LIST"

echo "✅ Backup complete. Stored in $BACKUP_DIR"
